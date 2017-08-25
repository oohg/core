/*
 * $Id: toolbed.prg,v 1.17 2017-08-25 18:20:41 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2017 Ciro Vargas Clemow <cvc@oohg.org>
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
 * along with this software. If not, visit the web site:
 * <http://www.gnu.org/licenses/>
 *
 */

#include "dbstruct.ch"
#include "oohg.ch"
#include "hbclass.ch"

#define CRLF Chr( 13 ) + Chr( 10 )
#define UpperNIL( cValue ) IIF( Upper( AllTrim( cValue ) ) == 'NIL', 'NIL', cValue )
#define EDIT_ABORTED .T.
#define EDIT_SAVED .F.





CLASS TMyToolBarEditor

   DATA aToolBars              INIT {}
   DATA lChanged               INIT .F.
   DATA nLast                  INIT 0
   DATA oEditor                INIT NIL
   DATA oSplitBox              INIT NIL

   METHOD AddToolBar
   METHOD Count                BLOCK { |Self| Len( ::aToolBars ) }
   METHOD CreateToolBars
   METHOD DelToolBar
   METHOD Edit
   METHOD EditToolBar
   METHOD FmgOutput
   METHOD LoadToolBars
   METHOD MoveToolBarDown
   METHOD MoveToolBarUp
   METHOD New                  CONSTRUCTOR
   METHOD Release

ENDCLASS

//------------------------------------------------------------------------------
METHOD AddToolBar( cName ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL i, oTB

   DEFAULT cName TO 'toolbar_' + Ltrim( Str( ++ ::nLast ) )
   i := 1
   DO WHILE i <= ::Count
      oTB := ::aToolBars[ i ]
      IF Upper( oTB:Name ) == Upper( cName )
         cName := 'toolbar_' + Ltrim( Str( ++ ::nLast ) )
         i := 1
      ELSE
         i ++
      ENDIF
   ENDDO
   oTB := TMyToolBar():New( cName, ::oEditor )
   aAdd( ::aToolBars, oTB )
RETURN oTB

//------------------------------------------------------------------------------
METHOD DelToolBar( i ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF i > 0 .and. i <= ::Count
      ::aToolBars[ i ]:Release()
      aDel( ::aToolBars, i )
      aSize( ::aToolBars, ::Count - 1 )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oLst, oDel, oEdit

   SET INTERACTIVECLOSE ON
   LOAD WINDOW myTBSel
   ON KEY ESCAPE OF myTBSel ACTION myTBSel.Release()
   ACTIVATE WINDOW myTBSel
   SET INTERACTIVECLOSE OFF
   ::CreateToolBars()
   ::oEditor:oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateToolBars() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oTB

   IF HB_IsObject( ::oSplitBox )
      FOR EACH oTB IN ::aToolBars
         IF HB_IsObject( oTB:oTBCtrl )
            oTB:oTBCtrl:Release()
         ENDIF
      NEXT
      ::oSplitBox:Release()
   ENDIF
   IF Len( ::aToolBars ) > 1
      DEFINE SPLITBOX OF ( ::oEditor:oDesignForm:Name ) OBJ ::oSplitBox
   ENDIF
   FOR EACH oTB IN ::aToolBars
      oTB:CreateCtrl()
   NEXT
   IF Len( ::aToolBars ) > 1
      END SPLITBOX
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD EditToolBar( i ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL lRet

   IF i > 0 .and. i <= ::Count
      IF ( lRet := ::aToolBars[ i ]:Edit() ) == EDIT_SAVED
         ::lChanged := .T.
      ELSE
         ::aToolBars[ i ]:ReadFromFMG()
      ENDIF
   ELSE
      lRet := EDIT_ABORTED
   ENDIF
RETURN lRet

//------------------------------------------------------------------------------
METHOD FmgOutput( nSpacing ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oTB, cOutput := ''

   IF Len( ::aToolBars ) > 1
      cOutput += "DEFINE SPLITBOX" + CRLF
   ENDIF
   FOR EACH oTB IN ::aToolBars
      cOutput += oTB:FmgOutput( nSpacing )
   NEXT
   FOR EACH oTB IN ::aToolBars
      oTB:CreateCtrl()
   NEXT
   IF Len( ::aToolBars ) > 1
      cOutput += "END SPLITBOX" + CRLF + CRLF
   ENDIF
RETURN cOutput

//------------------------------------------------------------------------------
 METHOD LoadToolBars() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL i := 1, cName, oTB

   ::aToolBars := {}
   ::lChanged := .F.
   DO WHILE i <= Len( ::oEditor:aLine )
      IF At( 'DEFINE TOOLBAR ', Upper( LTrim( ::oEditor:aLine[ i ] ) ) ) == 1
         cName := ::oEditor:ReadCtrlName( i )
         IF ! Empty( cName )
            oTB := ::AddToolBar( cName )
            oTB:ReadFromFMG()
         ENDIF
      ENDIF
      i ++
   ENDDO
   ::CreateToolBars()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveToolBarDown( i ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oTB

   IF i > 0 .and. i < ::Count
      oTB := ::aToolBars[ i ]
      aDel( ::aToolBars, i )
      i ++
      aIns( ::aToolBars, i )
      ::aToolBars[ i ] := oTB
      ::lChanged := .T.
   ENDIF
RETURN i

//------------------------------------------------------------------------------
METHOD MoveToolBarUp( i ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oTB

   IF i > 1 .and. i <= ::Count
      oTB := ::aToolBars[ i ]
      aDel( ::aToolBars, i )
      i --
      aIns( ::aToolBars, i )
      ::aToolBars[ i ] := oTB
      ::lChanged := .T.
   ENDIF
RETURN i

//------------------------------------------------------------------------------
METHOD New( oEditor ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ::oEditor := oEditor
RETURN Self

//------------------------------------------------------------------------------
METHOD Release() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL oTB

   FOR EACH oTB IN ::aToolBars
      oTB:Release()
   NEXT
   ::aToolBars := {}
   ::oEditor := NIL
RETURN NIL





CLASS TMyToolBar

   DATA aButtons               INIT {}
   DATA aData                  INIT {}
   DATA cAction                INIT ''
   DATA cCaption               INIT ''
   DATA cFont                  INIT 'Arial'
   DATA cObj                   INIT ''
   DATA cSubclass              INIT ''
   DATA cToolTip               INIT ''
   DATA FormEdit               INIT NIL
   DATA lBold                  INIT .F.
   DATA lBorder                INIT .T.
   DATA lBottom                INIT .F.
   DATA lBreak                 INIT .F.
   DATA lFlat                  INIT .F.
   DATA lItalic                INIT .F.
   DATA lNoBreak               INIT .F.
   DATA lNoTabStop             INIT .F.
   DATA lRightText             INIT .F.
   DATA lRTL                   INIT .F.
   DATA lEditResult            INIT EDIT_ABORTED
   DATA lOwnTT                 INIT .F.
   DATA lStrikeout             INIT .F.
   DATA lUnderline             INIT .F.
   DATA lVertical              INIT .F.
   DATA Name                   INIT ''
   DATA nColorB                INIT 0
   DATA nColorG                INIT 0
   DATA nColorR                INIT 0
   DATA nHeight                INIT 65
   DATA nLastBtn               INIT 0
   DATA nSize                  INIT 10
   DATA nWidth                 INIT 65
   DATA oEditor                INIT NIL
   DATA oTBCtrl                INIT NIL

   METHOD AddBtn
   METHOD CreateCtrl
   METHOD DeleteBtn
   METHOD Discard
   METHOD Edit
   METHOD EditDropDownButton
   METHOD FmgOutput
   METHOD InsertBtn
   METHOD MoveDown
   METHOD MoveUp
   METHOD New                  CONSTRUCTOR
   METHOD OnEditInit
   METHOD OnGridChange
   METHOD PreProcessDefine
   METHOD ReadFromFMG
   METHOD ReadToolBarLogicalData
   METHOD ReadToolBarStringData
   METHOD Release
   METHOD Save
   METHOD SetFont
   METHOD WriteAction
   METHOD WriteAutosize
   METHOD WriteCaption
   METHOD WriteCheck
   METHOD WriteGroup
   METHOD WriteName
   METHOD WriteObj
   METHOD WritePicture
   METHOD WriteSeparator
   METHOD WriteSubclass
   METHOD WriteToolTip
   METHOD WriteWhole

ENDCLASS

//------------------------------------------------------------------------------
METHOD AddBtn() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut, nNew

   ::nLastBtn ++
   oBut := TMyTBBtn():New( ::Name + '_button_' + LTrim( Str( ::nLastBtn ) ), ::oEditor )
   aAdd( ::aButtons, oBut )

   nNew := ::FormEdit:grd_Buttons:ItemCount + 1
   ::FormEdit:grd_Buttons:InsertItem( nNew, { oBut:Name, '', '', .F., .F., '', .F., .F., '', '', .F., .F., '' } )
   ::FormEdit:grd_Buttons:Value := nNew
   ::FormEdit:grd_Buttons:SetFocus()

   IF Len( ::aButtons ) > 1
      ::FormEdit:btn_Up:Enabled := .T.
      ::FormEdit:btn_Down:Enabled := .T.
   ELSE
      ::FormEdit:btn_Insert:Enabled := .T.
      ::FormEdit:btn_Delete:Enabled := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateCtrl() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL i

   IF HB_IsObject( ::oTBCtrl )
      ::oTBCtrl:Release()
   ENDIF

   ::oTBCtrl := TToolBar():Define( 0, ::oEditor:oDesignForm, 0, 0, ::nWidth, ;
                                   ::nHeight, ::cCaption, NIL, ::cFont, ;
                                   ::nSize, ::cToolTip, ::lFlat, ::lBottom, ;
                                   ::lRightText, ::lBreak, ::lBold, ::lItalic, ;
                                   ::lUnderline, ::lStrikeout, ::lBorder, ;
                                   ::lRTL, ::lNoTabStop, ::lVertical, ::lOwnTT )

   FOR i := 1 TO Len( ::aButtons )
       ::aButtons[ i ]:CreateCtrl()
   NEXT i

   _EndToolBar( ! ::lNoBreak )
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteBtn() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL nLen, nBut

   nBut := ::FormEdit:grd_Buttons:Value
   nLen := Len( ::aButtons )
   IF nBut > 0 .AND. nBut <= nLen
      aDel( ::aButtons, nBut )
      aSize( ::aButtons, nLen - 1 )

      ::FormEdit:grd_Buttons:DeleteItem( nBut )
      ::FormEdit:grd_Buttons:Value := Min( nBut, ::FormEdit:grd_Buttons:ItemCount )
      ::FormEdit:grd_Buttons:SetFocus()

      ::OnGridChange()

      IF Len( ::aButtons ) > 0
         IF Len( ::aButtons ) == 1
            ::FormEdit:btn_Up:Enabled := .F.
            ::FormEdit:btn_Down:Enabled := .F.
         ENDIF
      ELSE
         ::FormEdit:btn_Insert:Enabled := .F.
         ::FormEdit:btn_Delete:Enabled := .F.
         ::FormEdit:btn_Up:Enabled     := .F.
         ::FormEdit:btn_Down:Enabled   := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Discard() CLASS TMyToolBar
//------------------------------------------------------------------------------
   IF MsgYesNo( "Changes will be discarded, are you sure?", 'OOHG IDE+' )
      ::FormEdit:Release()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit() CLASS TMyToolBar
//------------------------------------------------------------------------------
   SET INTERACTIVECLOSE ON
   LOAD WINDOW myToolBarEd
   ON KEY ESCAPE OF myToolBarEd ACTION ::Discard()
   ACTIVATE WINDOW myToolBarEd
   SET INTERACTIVECLOSE OFF

   ::oEditor:oDesignForm:SetFocus()
RETURN ::lEditResult

//------------------------------------------------------------------------------
METHOD FmgOutput( nSpacing ) CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL cOutput := '', oBut, oMenu

   cOutput += Space( nSpacing ) + 'DEFINE TOOLBAR ' + AllTrim( ::Name ) + ' ;' + CRLF
   cOutput += Space( nSpacing * 2 ) + 'BUTTONSIZE ' + LTrim( Str( ::nWidth ) ) + ',' + LTrim( Str( ::nHeight ) )       // Do not add a space after the comma
   cOutput += IIF( Empty( ::cObj ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'OBJ ' + AllTrim( ::cObj ) )
   cOutput += IIF( Empty( ::cFont ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::cFont ) )
   cOutput += IIF( ::nSize > 0, ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::nSize ) ), '' )
   cOutput += IIF( ::lBold, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD ', '' )
   cOutput += IIF( ::lItalic, ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC ', '' )
   cOutput += IIF( ::lUnderline, ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE ', '' )
   cOutput += IIF( ::lStrikeout, ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT ', '' )
   cOutput += IIF( Empty( ::cToolTip ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOOLTIP ' + StrToStr( ::cToolTip, .T. ) )
   cOutput += IIF( ::lOwnTT, ' ;' + CRLF + Space( nSpacing * 2 ) + 'OWNTOOLTIP ', '' )
   cOutput += IIF( ::lFlat, ' ;' + CRLF + Space( nSpacing * 2 ) + 'FLAT ', '' )
   cOutput += IIF( ::lBottom, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOTTOM ', '' )
   cOutput += IIF( ::lRightText, ' ;' + CRLF + Space( nSpacing * 2 ) + 'RIGHTTEXT ', '' )
   cOutput += IIF( ::lBorder, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BORDER ', '' )
   cOutput += IIF( ::lVertical, ' ;' + CRLF + Space( nSpacing * 2 ) + 'VERTICAL ', '' )
   cOutput += IIF( ::lBreak, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BREAK ', '' )
   cOutput += IIF( ::lRTL, ' ;' + CRLF + Space( nSpacing * 2 ) + 'RTL ', '' )
   cOutput += IIF( ::lNoTabStop, ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOTABSTOP ', '' )
   cOutput += IIF( Empty( ::cCaption ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'CAPTION ' + StrToStr( ::cCaption, .T. ) )
   cOutput += IIF( Empty( ::cAction ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'ACTION ' + AllTrim( ::cAction ) )
   cOutput += IIF( Empty( ::cSubclass ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'SUBCLASS ' + AllTrim( ::cSubclass ) )
   cOutput += CRLF + CRLF

   FOR EACH oBut IN ::aButtons
      cOutput += oBut:FmgOutput( nSpacing )
   NEXT

   cOutput += Space( nSpacing ) + 'END TOOLBAR '
   cOutput += IIF( ::lNoBreak, ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOBREAK ', '' )
   cOutput += CRLF + CRLF

   // TODO: DROP DOWN MENU
   oMenu := TMyMenuEditor()
   oMenu:oEditor := ::oEditor
   oMenu:nType := 4
   FOR EACH oBut IN ::aButtons
      IF File( ::oEditor:cFName + '.' + oBut:Name + '.mnd' )
         cOutput += oMenu:FmgOutput( NIL, NIL, nSpacing, oBut:Name )
      ENDIF
   NEXT
RETURN cOutput

//------------------------------------------------------------------------------
METHOD InsertBtn() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL nBut, nLen, oBut

   nBut := ::FormEdit:grd_Buttons:Value
   nLen := Len( ::aButtons )
   IF nBut > 0 .AND. nBut <= nLen
      aSize( ::aButtons, nLen + 1 )
      aIns( ::aButtons, nBut )
      ::nLastBtn ++

      oBut := TMyTBBtn():New( ::Name + '_button_' + LTrim( Str( ::nLastBtn ) ), ::oEditor )
      ::aButtons[ nBut ] := oBut

      ::FormEdit:grd_Buttons:InsertItem( nBut, { oBut:Name, '', '', .F., .F., '', .F., .F., '', '', .F., .F., '' } )
      ::FormEdit:grd_Buttons:Value := Min( nBut, ::FormEdit:grd_Buttons:ItemCount )
      ::FormEdit:grd_Buttons:SetFocus()

      ::OnGridChange()

      IF Len( ::aButtons ) > 0
         IF Len( ::aButtons ) == 1
            ::FormEdit:btn_Up:Enabled := .F.
            ::FormEdit:btn_Down:Enabled := .F.
         ENDIF
      ELSE
         ::FormEdit:btn_Insert:Enabled := .F.
         ::FormEdit:btn_Delete:Enabled := .F.
      ENDIF
   ENDIF

   ::FormEdit:grd_Buttons:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveDown() CLASS TMyToolBar
//------------------------------------------------------------------------------
   IF ::FormEdit:grd_Buttons:Value < 1
      IF ::FormEdit:grd_Buttons:ItemCount > 0
         ::FormEdit:grd_Buttons:Value := 1
      ENDIF
   ELSE
      IF ::FormEdit:grd_Buttons:Value < ::FormEdit:grd_Buttons:ItemCount
         ::FormEdit:grd_Buttons:Value := ::FormEdit:grd_Buttons:Value + 1
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveUp() CLASS TMyToolBar
//------------------------------------------------------------------------------
   IF ::FormEdit:grd_Buttons:Value > 1
      ::FormEdit:grd_Buttons:Value := ::FormEdit:grd_Buttons:Value - 1
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD New( cName, oEditor ) CLASS TMyToolBar
//------------------------------------------------------------------------------
   ::Name    := cName
   ::oEditor := oEditor
RETURN Self

//------------------------------------------------------------------------------
METHOD OnEditInit() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   ::FormEdit:txt_Name:Value     := ::Name
   ::FormEdit:txt_Width:Value    := ::nWidth
   ::FormEdit:txt_Height:Value   := ::nHeight
   ::FormEdit:txt_ToolTip:Value  := ::cToolTip
   ::FormEdit:chk_OwnTT:Value    := ::lOwnTT
   ::FormEdit:chk_Flat:Value     := ::lFlat
   ::FormEdit:chk_Bottom:Value   := ::lBottom
   ::FormEdit:chk_Right:Value    := ::lRightText
   ::FormEdit:chk_Border:Value   := ::lBorder
   ::FormEdit:chk_Vert:Value     := ::lVertical
   ::FormEdit:chk_RTL:Value      := ::lRTL
   ::FormEdit:chk_NoTab:Value    := ::lNoTabStop
   ::FormEdit:chk_Break:Value    := ::lBreak
   ::FormEdit:chk_NoBreak:Value  := ::lNoBreak
   ::FormEdit:txt_Ojb:Value      := ::cObj
   ::FormEdit:txt_Caption:Value  := ::cCaption
   ::FormEdit:txt_Action:Value   := ::cAction
   ::FormEdit:txt_Subclass:Value := ::cSubclass

   FOR EACH oBut IN ::aButtons
      WITH OBJECT oBut
         ::FormEdit:grd_Buttons:AddItem( { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   NEXT

   IF Len( ::aButtons ) > 0
      ::FormEdit:grd_Buttons:Value := 1
      IF Len( ::aButtons ) == 1
         ::FormEdit:btn_Up:Enabled := .F.
         ::FormEdit:btn_Down:Enabled := .F.
      ENDIF
   ELSE
      ::FormEdit:btn_Insert:Enabled := .F.
      ::FormEdit:btn_Delete:Enabled := .F.
      ::FormEdit:btn_Up:Enabled     := .F.
      ::FormEdit:btn_Down:Enabled   := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD OnGridChange() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      ::FormEdit:txt_ItCaption:Value   := oBut:cCaption
      ::FormEdit:txt_ItName:Value      := oBut:Name
      ::FormEdit:txt_ItAction:Value    := oBut:cAction
      ::FormEdit:txt_ItPicture:Value   := oBut:cPicture
      ::FormEdit:txt_ItToolTip:Value   := oBut:cToolTip
      ::FormEdit:txt_ItObj:Value       := oBut:cObj
      ::FormEdit:txt_ItSubclass:Value  := oBut:cSubclass
      ::FormEdit:chk_ItCheck:Value     := oBut:lCheck
      ::FormEdit:chk_ItAutosize:Value  := oBut:lAutosize
      ::FormEdit:chk_ItSeparator:Value := oBut:lSeparator
      ::FormEdit:chk_ItGroup:Value     := oBut:lGroup
      ::FormEdit:chk_ItWhole:Value     := oBut:lWhole
   ELSE
      ::FormEdit:txt_ItCaption:Value   := ""
      ::FormEdit:txt_ItName:Value      := ""
      ::FormEdit:txt_ItAction:Value    := ""
      ::FormEdit:txt_ItPicture:Value   := ""
      ::FormEdit:txt_ItToolTip:Value   := ""
      ::FormEdit:txt_ItObj:Value       := ""
      ::FormEdit:txt_ItSubclass:Value  := ""
      ::FormEdit:chk_ItCheck:Value     := .F.
      ::FormEdit:chk_ItAutosize:Value  := .F.
      ::FormEdit:chk_ItSeparator:Value := .F.
      ::FormEdit:chk_ItGroup:Value     := .F.
      ::FormEdit:chk_ItWhole:Value     := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD PreProcessDefine() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL zi, zf, i, cData := "", cStr, sw, nl

   // Concatenate lines
   IF ( i := aScan( ::oEditor:aControlW, Lower( ::Name ) ) ) > 0
      zi := ::oEditor:aSpeed[ i ]
      zf := ::oEditor:aNumber[ i ]
      FOR i := zi TO zf
         IF Empty( ::oEditor:aLine[ i ] )
            EXIT
         ENDIF
         cData += ::oEditor:aLine[ i ]
      NEXT i
      // Separate keywords and arguments
      cStr := ""
      sw := .F.
      nl := 0
      FOR EACH i IN hb_ATokens( cData, " ", .T., .F. )
         IF sw
            cStr += ( i + " " )
            IF Right( i, 1 ) == "}"
               nl --
               IF nl == 0
                  sw := .F.
                  aAdd( ::aData, cStr )
                  cStr := ""
               ENDIF
            ENDIF
         ELSEIF Left( i, 1 ) == "{"
            cStr += ( i + " " )
            sw := .T.
            nl ++
         ELSEIF i != NIL .AND. ! Empty( i ) .and. i # ";"
            IF Right( i, 1 ) == ";"
               i := SubStr( i, 1, Len( i ) - 1 )
            ENDIF
            aAdd( ::aData, i )
         ENDIF
      NEXT
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadFromFMG() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL i, cLine, cName, cSize, nPos, nVal, oBut

   IF ( i := aScan( ::oEditor:aControlW, Lower( ::Name ) ) ) > 0
      ::PreProcessDefine()

      ::cObj       := ::ReadToolBarStringData( 'OBJ', ::cObj )
      ::cCaption   := ::oEditor:Clean( ::ReadToolBarStringData( 'CAPTION', ::cCaption ) )
      ::cCaption   := ::oEditor:Clean( ::ReadToolBarStringData( 'GRIPPERTEXT', ::cCaption ) )
      ::cAction    := ::ReadToolBarStringData( 'ACTION', ::cAction )
      ::cFont      := ::oEditor:Clean( ::ReadToolBarStringData( 'FONT', ::cFont ) )
      ::cFont      := ::oEditor:Clean( ::ReadToolBarStringData( 'FONTNAME', ::cFont ) )
      ::nSize      := Val( ::ReadToolBarStringData( 'SIZE', LTrim( Str( ::nSize ) ) ) )
      ::nSize      := Val( ::ReadToolBarStringData( 'FONTSIZE', LTrim( Str( ::nSize ) ) ) )
      ::lBold      := ::ReadToolBarLogicalData( 'BOLD', ::lBold )
      ::lBold      := ::ReadToolBarLogicalData( 'FONTBOLD', ::lBold )
      ::lItalic    := ::ReadToolBarLogicalData( 'ITALIC', ::lItalic )
      ::lItalic    := ::ReadToolBarLogicalData( 'FONTITALIC', ::lItalic )
      ::lUnderline := ::ReadToolBarLogicalData( 'UNDERLINE', ::lUnderline )
      ::lUnderline := ::ReadToolBarLogicalData( 'FONTUNDERLINE', ::lUnderline )
      ::lStrikeout := ::ReadToolBarLogicalData( 'STRIKEOUT', ::lStrikeout )
      ::lStrikeout := ::ReadToolBarLogicalData( 'FONTSTRIKEOUT', ::lStrikeout )
      ::cToolTip   := ::oEditor:Clean( ::ReadToolBarStringData( 'TOOLTIP', ::cToolTip ) )
      ::lOwnTT     := ::ReadToolBarLogicalData( 'OWNTOOLTIP', ::lFlat )
      ::lFlat      := ::ReadToolBarLogicalData( 'FLAT', ::lFlat )
      ::lBottom    := ::ReadToolBarLogicalData( 'BOTTOM', ::lBottom )
      ::lVertical  := ::ReadToolBarLogicalData( 'VERTICAL', ::lVertical )
      ::lRightText := ::ReadToolBarLogicalData( 'RIGHTTEXT', ::lRightText )
      ::lBorder    := ::ReadToolBarLogicalData( 'BORDER', ::lBorder )
      ::lBreak     := ::ReadToolBarLogicalData( 'BREAK', ::lBreak )
      ::lRTL       := ::ReadToolBarLogicalData( 'RTL', ::lRTL )
      ::cSubClass  := ::ReadToolBarStringData( 'SUBCLASS', ::cSubClass )
      ::lNoTabStop := ::ReadToolBarLogicalData( 'NOTABSTOP', ::lNoTabStop )

      cSize := ::ReadToolBarStringData( 'BUTTONSIZE', '' )
      IF ( nPos := At( ',', cSize ) ) > 0
         IF ( nVal := Val( SubStr( cSize, 1, nPos - 1 ) ) ) > 0
            ::nWidth := nVal
         ENDIF
         IF ( nVal := Val( SubStr( cSize, nPos + 1 ) ) ) > 0
            ::nHeight := nVal
         ENDIF
      ELSE
         IF ( nVal := Val( cSize ) ) > 0
           ::nWidth := nVal
         ENDIF
      ENDIF
      /*
      aFontColor := UpperNIL( ::ReadToolBarStringData( 'FONTCOLOR', 'NIL' ) )
      IF IsValidArray( aFontColor )
         ::nColorR := aFontColor[ 1 ]
         ::nColorG := aFontColor[ 2 ]
         ::nColorB := aFontColor[ 3 ]
      ELSEIF Type( aFontColor ) == 'N'
         ::nColorR := GetRed( aFontColor )
         ::nColorG := GetGreen( aFontColor )
         ::nColorB := GetBlue( aFontColor )
      ENDIF
      */

      ::aButtons := {}
      DO WHILE i < Len( ::oEditor:aLine )
         i ++
         cLine := Upper( LTrim( ::oEditor:aLine[ i ] ) )
         IF At( 'DEFINE TBBUTTON ', cLine ) == 1
            cName := ::oEditor:ReadCtrlName( i )
            IF ! Empty( cName )
               oBut := TMyTBBtn():New( cName, ::oEditor )
               aAdd( ::aButtons, oBut )
               oBut:ReadFromFMG()
            ENDIF
         ELSEIF At( 'END TOOLBAR', cLine ) == 1 .OR. At( 'END WINDOW', cLine ) == 1
            ::lNoBreak := ( AllTrim( SubStr( cLine, 12 ) ) == 'NOBREAK' )
            EXIT
         ENDIF
      ENDDO
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadToolBarLogicalData( cProp, lDefault ) CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL i

   FOR EACH i IN ::aData
      IF Upper( i ) == cProp
         RETURN .T.
      ENDIF
   NEXT i
RETURN lDefault

//------------------------------------------------------------------------------
METHOD ReadToolBarStringData( cProp, cDefault ) CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL nLen, i, c2, c1

   IF ( i := At( " ", cProp ) ) > 0
      c1 := SubStr( cProp, 1, i - 1 )
      c2 := SubStr( cProp, i + 1 )
      nLen := Len( ::aData ) - 2
      FOR i := 1 TO nLen
         IF Upper( ::aData[ i ] ) == c1
            IF Upper( ::aData[ i + 1 ] ) == c2
               RETURN ::aData[ i + 2 ]
            ENDIF
         ENDIF
      NEXT i
   ELSE
      nLen := Len( ::aData ) - 1
      FOR i := 1 TO nLen
         IF Upper( ::aData[ i ] ) == cProp
            RETURN ::aData[ i + 1 ]
         ENDIF
      NEXT i
   ENDIF
RETURN cDefault

//------------------------------------------------------------------------------
METHOD Release() CLASS TMyToolBar
//------------------------------------------------------------------------------
   ::aButtons := {}
   ::oEditor := NIL
   IF HB_IsObject( ::oTBCtrl )
      ::oTBCtrl:Release()
      ::oTBCtrl := NIL
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Save() CLASS TMyToolBar
//------------------------------------------------------------------------------
   DO CASE
   CASE Empty( ::Name )
      MsgStop( 'ToolBar must have a name.', 'OOHG IDE+' )
   CASE ::nWidth <= 0
      MsgStop( 'Width must be greater than 0.', 'OOHG IDE+' )
   CASE ::nHeight <= 0
      MsgStop( 'Height must be greater than 0.', 'OOHG IDE+' )
   OTHERWISE
      ::lEditResult := EDIT_SAVED       // TODO: ver si algo cambió
      ::FormEdit:Release()
   ENDCASE
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetFont() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL aFont, cColor

   cColor := '{' + Str( ::nColorR, 3 ) + ',' + Str( ::nColorG, 3 ) + ',' + Str( ::nColorB, 3 ) + '}'
   aFont := GetFont( ::cFont, ::nSize, ::lBold, ::lItalic, &cColor, ::lUnderline, ::lStrikeout, 0 )
   IF aFont[ 1 ] == ''
      RETURN NIL
   ENDIF
   ::cFont      := aFont[ 1 ]
   ::nSize      := aFont[ 2 ]
   ::lBold      := aFont[ 3 ]
   ::lItalic    := aFont[ 4 ]
   ::nColorR    := aFont[ 5, 1 ]
   ::nColorG    := aFont[ 5, 2 ]
   ::nColorB    := aFont[ 5, 3 ]
   ::lUnderline := aFont[ 6 ]
   ::lStrikeout := aFont[ 7 ]
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteAction() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cAction := ::FormEdit:txt_ItAction:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteAutosize() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :lAutosize := ::FormEdit:chk_ItAutosize:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteCaption() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cCaption := ::FormEdit:txt_ItCaption:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteCheck() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :lCheck := ::FormEdit:chk_ItCheck:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteGroup() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :lGroup := ::FormEdit:chk_ItGroup:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteName() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL i, oBut, cNewName

   IF ::FormEdit:grd_Buttons:Value > 0
      cNewName := Upper( AllTrim( ::FormEdit:txt_ItName:Value ) )

      FOR i := 1 to Len( ::aButtons )
         IF i # ::FormEdit:grd_Buttons:Value
            oBut := ::aButtons[ i ]
            IF Upper( oBut:Name ) == cNewName
               MsgStop( 'Another button has the same name.', 'OOHG IDE+' )
               RETURN NIL
            ENDIF
         ENDIF
      NEXT i

      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         IF Empty( cNewName )
            MsgStop( 'Button must have a name.', 'OOHG IDE+' )
            ::FormEdit:txt_ItName:Value := :Name
            RETURN NIL
         ENDIF

         :Name := AllTrim( ::FormEdit:txt_ItName:Value )
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteObj() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cObj := ::FormEdit:txt_ItObj:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WritePicture() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cPicture := ::FormEdit:txt_ItPicture:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteSeparator() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :lSeparator := ::FormEdit:chk_ItSeparator:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteSubclass() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cSubclass := ::FormEdit:txt_ItSubclass:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteToolTip() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         :cToolTip := ::FormEdit:txt_ItToolTip:Value
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteWhole() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         IF :lDrop
            :lWhole := ::FormEdit:chk_ItWhole:Value
            ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
         ELSE
            MsgStop( 'Button has no dropdown menu.', 'OOHG IDE+' )
         ENDIF
      END WITH
   ENDIF
RETURN NIL

//TODO: from here
//------------------------------------------------------------------------------
METHOD EditDropDownButton() CLASS TMyToolBar
//------------------------------------------------------------------------------
LOCAL oBut

   IF ::FormEdit:grd_Buttons:Value > 0
      oBut := ::aButtons[ ::FormEdit:grd_Buttons:Value ]

      WITH OBJECT oBut
         TMyMenuEditor():Edit( ::oEditor, 4, :Name )
         :lDrop := File( ::oEditor:cFName + '.' + :Name + '.mnd' )
         IF ! :lDrop
            :lWhole := .F.
         ENDIF
         ::FormEdit:grd_Buttons:Item( ::FormEdit:grd_Buttons:Value, { :Name, :cCaption, :cAction, :lCheck, :lAutosize, :cPicture, :lSeparator, :lGroup, :cTooltip, :cObj, :lDrop, :lWhole, :cSubclass } )
      END WITH
   ENDIF
RETURN NIL





CLASS TMyTBBtn

   DATA aData                  INIT {}
   DATA cAction                INIT ''
   DATA cCaption               INIT ''
   DATA cObj                   INIT ''
   DATA cPicture               INIT ''
   DATA cToolTip               INIT ''
   DATA cSubclass              INIT ''
   DATA lAutosize              INIT .F.
   DATA lCheck                 INIT .F.
   DATA lDrop                  INIT .F.
   DATA lGroup                 INIT .F.
   DATA lSeparator             INIT .F.
   DATA lWhole                 INIT .F.
   DATA Name                   INIT ''
   DATA oEditor                INIT NIL

   METHOD CreateCtrl
   METHOD FmgOutput
   METHOD New                  CONSTRUCTOR                                      
   METHOD PreProcessDefine                                                      
   METHOD ReadFromFMG                                                           
   METHOD ReadTBBtnLogicalData                                                  
   METHOD ReadTBBtnStringData                                                   

ENDCLASS

//------------------------------------------------------------------------------
METHOD FmgOutput( nSpacing ) CLASS TMyTBBtn
//------------------------------------------------------------------------------
LOCAL cOutput := ''

   cOutput += Space( nSpacing * 2 ) + 'BUTTON ' + AllTrim( ::Name )
   cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CAPTION ' + StrToStr( ::cCaption )
   IF ! Empty( ::cPicture )
     cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'PICTURE ' + StrToStr( ::cPicture )
   ENDIF
   cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cAction )
   IF ::lSeparator
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'SEPARATOR '
   ENDIF
   IF ::lAutosize
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'AUTOSIZE '
   ENDIF
   IF ::lCheck
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CHECK '
   ENDIF
   IF ::lGroup
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'GROUP '
   ENDIF
   IF ::lWhole
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WHOLEDROPDOWN '
   ELSEIF ::lDrop
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'DROPDOWN '
   ENDIF
   IF ! Empty( ::cToolTip )
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cToolTip )
   ENDIF
   IF ! Empty( ::cObj )
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'OBJ ' + AllTrim( ::cObj )
   ENDIF
   IF ! Empty( ::cSubclass )
      cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'SUBCLASS ' + AllTrim( ::cSubclass )
   ENDIF
   cOutput += CRLF + CRLF
RETURN cOutPut

//------------------------------------------------------------------------------
METHOD New( cName, oEditor ) CLASS TMyTBBtn
//------------------------------------------------------------------------------
   ::Name := cName
   ::oEditor := oEditor
RETURN Self

//------------------------------------------------------------------------------
METHOD PreProcessDefine() CLASS TMyTBBtn
//------------------------------------------------------------------------------
LOCAL zi, zf, i, cData := "", cStr, sw, nl

   // Concatenate lines
   IF ( i := aScan( ::oEditor:aControlW, Lower( ::Name ) ) ) > 0
      zi := ::oEditor:aSpeed[ i ]
      zf := ::oEditor:aNumber[ i ]
      FOR i := zi TO zf
         IF Empty( ::oEditor:aLine[ i ] )
            EXIT
         ENDIF
         cData += ::oEditor:aLine[ i ]
      NEXT i
      // Separate keywords and arguments
      cStr := ""
      sw := .F.
      nl := 0
      FOR EACH i IN hb_ATokens( cData, " ", .T., .F. )
         IF sw
            cStr += ( i + " " )
            IF Right( i, 1 ) == "}"
               nl --
               IF nl == 0
                  sw := .F.
                  aAdd( ::aData, cStr )
                  cStr := ""
               ENDIF
            ENDIF
         ELSEIF Left( i, 1 ) == "{"
            cStr += ( i + " " )
            sw := .T.
            nl ++
         ELSEIF i != NIL .AND. ! Empty( i ) .and. i # ";"
            IF Right( i, 1 ) == ";"
               i := SubStr( i, 1, Len( i ) - 1 )
            ENDIF
            aAdd( ::aData, i )
         ENDIF
      NEXT
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadFromFMG() CLASS TMyTBBtn
//------------------------------------------------------------------------------
   ::PreProcessDefine()

   ::cObj       := ::ReadTBBtnStringData( 'OBJ', '' )
   ::cCaption   := ::oEditor:Clean( ::ReadTBBtnStringData( 'CAPTION', '' ) )
   ::cPicture   := ::oEditor:Clean( ::ReadTBBtnStringData( 'PICTURE', '' ) )
   ::cAction    := ::ReadTBBtnStringData( 'ACTION', '' )
   ::cAction    := ::ReadTBBtnStringData( 'ON CLICK', ::cAction )
   ::cAction    := ::ReadTBBtnStringData( 'ONCLICK', ::cAction )
   ::cToolTip   := ::oEditor:Clean( ::ReadTBBtnStringData( 'TOOLTIP', '' ) )
   ::lSeparator := ::ReadTBBtnLogicalData( 'SEPARATOR', .F. )
   ::lAutoSize  := ::ReadTBBtnLogicalData( 'AUTOSIZE', .F. )
   ::lCheck     := ::ReadTBBtnLogicalData( 'CHECK', .F. )
   ::lGroup     := ::ReadTBBtnLogicalData( 'GROUP', .F. )
   ::lWhole     := ::ReadTBBtnLogicalData( 'WHOLEDROPDOWN', .F. )
   ::lDrop      := ::lWhole .OR. ::ReadTBBtnLogicalData( 'DROPDOWN', .F. )
   ::cSubClass  := ::ReadTBBtnStringData( 'SUBCLASS', '' )
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadTBBtnStringData( cProp, cDefault ) CLASS TMyTBBtn
//------------------------------------------------------------------------------
LOCAL nLen, i, c2, c1

   IF ( i := At( " ", cProp ) ) > 0
      c1 := SubStr( cProp, 1, i - 1 )
      c2 := SubStr( cProp, i + 1 )
      nLen := Len( ::aData ) - 2
      FOR i := 1 TO nLen
         IF Upper( ::aData[ i ] ) == c1
            IF Upper( ::aData[ i + 1 ] ) == c2
               RETURN ::aData[ i + 2 ]
            ENDIF
         ENDIF
      NEXT i
   ELSE
      nLen := Len( ::aData ) - 1
      FOR i := 1 TO nLen
         IF Upper( ::aData[ i ] ) == cProp
            RETURN ::aData[ i + 1 ]
         ENDIF
      NEXT i
   ENDIF
RETURN cDefault

//------------------------------------------------------------------------------
METHOD ReadTBBtnLogicalData( cProp, lDefault ) CLASS TMyTBBtn
//------------------------------------------------------------------------------
LOCAL i

   FOR EACH i IN ::aData
      IF Upper( i ) == cProp
         RETURN .T.
      ENDIF
   NEXT i
RETURN lDefault

//------------------------------------------------------------------------------
METHOD CreateCtrl() CLASS TMyTBBtn
//------------------------------------------------------------------------------
LOCAL oBut

   // TODO: Add support for image from RC file
   oBut := TToolButton():Define( 0, 0, 0, AllTrim( ::cCaption ), NIL, NIL, ;
                                 NIL, ::cPicture, ::cToolTip, NIL, NIL, .F., ;
                                 ::lSeparator, ::lAutosize, ::lCheck, ;
                                 ::lGroup, ::lDrop, ::lWhole )

   IF ::lDrop .OR. ::lWhole
      // DROPDOWN MENU
      // TODO: load from FMG file
      TMyMenuEditor():CreateMenuFromFile( ::oEditor, 4, ::Name, oBut )
   ENDIF
RETURN NIL

/*
 * EOF
 */
