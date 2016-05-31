/*
 * $Id: toolbed.prg,v 1.15 2016-05-31 22:30:08 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2016 Ciro Vargas Clemow <cvc@oohg.org>
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

#define CRLF Chr(13) + Chr(10)

CLASS TMyToolBarEditor

   DATA cAction    INIT ''
   DATA cCaption   INIT ''
   DATA cColorB    INIT 0
   DATA cColorG    INIT 0
   DATA cColorR    INIT 0
   DATA cFont      INIT ''
   DATA cID        INIT ''
   DATA cObj       INIT ''
   DATA cSubclass  INIT ''
   DATA cTbFile    INIT ''
   DATA cTbName    INIT 'toolbar_1'
   DATA cTooltip   INIT ''
   DATA FormEdit   INIT NIL
   DATA lBold      INIT .F.
   DATA lBorder    INIT .F.
   DATA lBottom    INIT .F.
   DATA lBreak     INIT .F.
   DATA lFlat      INIT .F.
   DATA lItalic    INIT .F.
   DATA lNoBreak   INIT .F.
   DATA lNoTabStop INIT .F.
   DATA lRightText INIT .F.
   DATA lRTL       INIT .F.
   DATA lStrikeout INIT .F.
   DATA lUnderline INIT .F.
   DATA lVertical  INIT .F.
   DATA nHeight    INIT 65
   DATA nSize      INIT 10
   DATA nWidth     INIT 65
   DATA oEditor    INIT NIL
   DATA oToolbar   INIT NIL

   METHOD AddItem
   METHOD CloseWorkArea
   METHOD CreateToolBarCtrl
   METHOD CreateToolBarFromFile
   METHOD DeleteItem
   METHOD Discard
   METHOD Edit
   METHOD EditDropDownButton
   METHOD Exit
   METHOD FmgOutput
   METHOD InsertItem
   METHOD MoveDown
   METHOD MoveUp
   METHOD New
   METHOD OpenWorkArea
   METHOD ParseData
   METHOD ParseItem
   METHOD Save
   METHOD SetFont
   METHOD WriteAction
   METHOD WriteAutosize
   METHOD WriteCaption
   METHOD WriteCheck
   METHOD WriteGroup
   METHOD WriteImage
   METHOD WriteName
   METHOD WriteObj
   METHOD WriteSeparator
   METHOD WriteSubclass
   METHOD WriteToolTip
   METHOD WriteWhole

ENDCLASS

//------------------------------------------------------------------------------
METHOD AddItem() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbAppend() )
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := ( ::cID )->( RecCount() )
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CloseWorkArea() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL cFile

   ( ::cID )->( dbCloseArea() )
   cFile := ::cID + '.dbf'
   IF File( cFile )
      ERASE ( cFile )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateToolBarCtrl() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL i := 1, oBut, cName

   IF HB_IsObject( ::oToolbar )
      ::oToolbar:Release()
      ::oToolbar := NIL
   ENDIF

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      // DEFINE TOOLBAR
      ::oToolbar := TToolBar():Define( ::cID, ::oEditor:oDesignForm, 0, 0, ;
                       ::nWidth, ::nHeight, ::cCaption, NIL, ::cFont, ::nSize, ;
                       ::cToolTip, ::lFlat, ::lBottom, ::lRightText, ::lBreak, ;
                       ::lBold, ::lItalic, ::lUnderline, ::lStrikeout, ::lBorder, ;
                       ::lRTL, ::lNoTabStop, ::lVertical )
         DO WHILE ! ( ::cID )->( Eof() )
            cName := "hmi_cvc_tb_button_" + AllTrim( Str( i, 2 ) )
            oBut := TToolButton():Define( cName, 0, 0, AllTrim( ( ::cID )->item ), ;
                       NIL, NIL, NIL, AllTrim( ( ::cID )->image ), ;
                       AllTrim( ( ::cID )->tooltip ), NIL, NIL, .F., ;
                       ( ::cID )->separator == 'X', ( ::cID )->autosize == 'X', ;
                       ( ::cID )->check == 'X', ( ::cID )->group == 'X', ;
                       ( ::cID )->drop == 'X', ( ::cID )->whole == "X" )

            IF ( ::cID )->drop == 'X' .OR. ( ::cID )->whole == "X"
               // DROPDOWN MENU
               TMyMenuEditor():CreateMenuFromFile( ::oEditor, 4, AllTrim( ( ::cID )->named ), oBut )
            ENDIF

            ( ::cID )->( dbSkip() )
            i ++
         ENDDO
      // END TOOLBAR
      _EndToolBar( ! ::lNoBreak )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateToolBarFromFile() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ::OpenWorkArea()
   ::ParseData()
   ::CreateToolBarCtrl()
   ::CloseWorkArea()
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteItem() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL cName

   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   cName := ::oEditor:cFName + '.' + AllTrim( ( ::cID )->named ) + '.mnd'
   IF File( cName )
      ERASE ( cName )
   ENDIF
   ( ::cID )->( dbDelete() )
   ( ::cID )->( __dbPack() )
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Discard() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ::FormEdit:Release()
   ::FormEdit := NIL
   ::CloseWorkArea()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ::OpenWorkArea()
   SET INTERACTIVECLOSE ON
   LOAD WINDOW myToolBarEd AS ( ::cID )
   ::FormEdit := GetFormObject( ::cID )
   IF ( ::cID )->( RecCount() ) > 0
      ::FormEdit:browse_101:Value := 1
   ENDIF
   ON KEY ESCAPE OF ( ::cID ) ACTION ::FormEdit:Release()
   ::ParseData()
   ACTIVATE WINDOW ( ::cID )
   SET INTERACTIVECLOSE OFF
   ::FormEdit := NIL
   ::oEditor:oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD EditDropDownButton() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   TMyMenuEditor():Edit( ::oEditor, 4, AllTrim( ( ::cID )->named ) )
   IF File( ::oEditor:cFName + '.' + AllTrim( ( ::cID )->named ) + '.mnd' )
      ( ::cID )->drop := 'X'
   ELSE
      ( ::cID )->drop := ' '
      ( ::cID )->whole := ' '
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL cFile

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      IF Empty( ::FormEdit:text_1:Value )
         MsgStop( 'ToolBar must have a name.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
      IF ::FormEdit:text_2:Value <= 0
         MsgStop( 'Width must be greater than 0.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
      IF ::FormEdit:text_3:Value <= 0
         MsgStop( 'Height must be greater than 0.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
      ::Save()
      ::CreateToolBarCtrl()
      ::FormEdit:Release()
      ::FormEdit := NIL
      ( ::cID )->( dbCloseArea() )
      cFile := ::cID + ".dbf"
      COPY FILE ( cFile ) TO ( ::cTbFile )
      ERASE ( cFile )
   ELSE
      IF HB_IsObject( ::oToolbar )
         ::oToolbar:Release()
         ::oToolbar := NIL
      ENDIF
      ::FormEdit:Release()
      ::FormEdit := NIL
      ( ::cID )->( dbCloseArea() )
      IF File( ::cTbFile )
         ERASE ( ::cTbFile )
      ENDIF
      ERASE ( ::cID + ".dbf" )
   ENDIF
   ::oEditor:lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD FmgOutput( nSpacing ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL cOutput := "", cButton, cFile, oMenu

   ::OpenWorkArea()
   ::ParseData()

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      cOutput += Space( nSpacing ) + 'DEFINE TOOLBAR ' + AllTrim( ::cTbName ) + ' ;' + CRLF
      cOutput += Space( nSpacing * 2 ) + 'BUTTONSIZE ' + LTrim( Str( ::nWidth ) ) + ', ' + LTrim( Str( ::nHeight ) )
      cOutput += IIF( Empty( ::cObj ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'OBJ ' + AllTrim( ::cObj ) )
      cOutput += IIF( Empty( ::cFont ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::cFont ) )
      cOutput += IIF( ::nSize > 0, ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::nSize ) ), '' )
      cOutput += IIF( ::lBold, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD ', '' )
      cOutput += IIF( ::lItalic, ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC ', '' )
      cOutput += IIF( ::lUnderline, ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE ', '' )
      cOutput += IIF( ::lStrikeout, ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT ', '' )
      cOutput += IIF( Empty( ::cToolTip ), '', ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOOLTIP ' + StrToStr( ::cToolTip, .T. ) )
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

      DO WHILE ! ( ::cID )->( Eof() )
         cOutput += Space( nSpacing * 2 ) + 'BUTTON ' + AllTrim( ( ::cID )->named )
         cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CAPTION ' + StrToStr( ( ::cID )->item )
         IF ! Empty( ( ::cID )->image )
           cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'PICTURE ' + StrToStr( ( ::cID )->image )
         ENDIF
         cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ( ::cID )->action )
         IF ( ::cID )->separator == 'X'
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'SEPARATOR '
         ENDIF
         IF ( ::cID )->autosize == 'X'
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'AUTOSIZE '
         ENDIF
         IF ( ::cID )->check == 'X'
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CHECK '
         ENDIF
         IF ( ::cID )->group == 'X'
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'GROUP '
         ENDIF
         IF ( ::cID )->whole == "X"
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + "WHOLEDROPDOWN "
         ELSEIF ( ::cID )->drop == 'X'
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + 'DROPDOWN '
         ENDIF
         IF ! Empty( ( ::cID )->tooltip )
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + "TOOLTIP " + StrToStr( ( ::cID )->tooltip )
         ENDIF
         IF ! Empty( ( ::cID )->obj )
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + "OBJ " + AllTrim( ( ::cID )->obj )
         ENDIF
         IF ! Empty( ( ::cID )->subclass )
            cOutput += ' ;' + CRLF + Space( nSpacing * 3 ) + "SUBCLASS " + AllTrim( ( ::cID )->subclass )
         ENDIF
         cOutput += CRLF + CRLF

         ( ::cID )->( dbSkip() )
      ENDDO

      cOutput += Space( nSpacing ) + 'END TOOLBAR '
      cOutput += IIF( ::lNoBreak, ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOBREAK ', '' )
      cOutput += CRLF + CRLF

      oMenu := TMyMenuEditor()
      oMenu:oEditor := ::oEditor
      oMenu:nType := 4              // Drop Down menu

      ( ::cID )->( dbGoTop() )
      DO WHILE ! ( ::cID )->( Eof() )
         cButton := AllTrim( ( ::cID )->named )
         cFile := ::oEditor:cFName + '.' + cButton + '.mnd'
         IF File( cFile )
            cOutput += oMenu:FmgOutput( NIL, NIL, nSpacing, cButton )
         ENDIF

         ( ::cID )->( dbSkip() )
      ENDDO
   ENDIF
   ::CloseWorkArea()
RETURN cOutput

//------------------------------------------------------------------------------
METHOD InsertItem() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, witem, wname, waction, wauxit, wimage, wtooltip, wcheck, wdrop
LOCAL wautosize, wseparator, wgroup, wwhole

   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   nRegAux := ( ::cID )->( RecNo() )

   ( ::cID )->( dbAppend() )

   DO WHILE ( ::cID )->( RecNo() ) > nRegAux
      ( ::cID )->( dbSkip( -1 ) )
      witem      := ( ::cID )->item
      wname      := ( ::cID )->named
      waction    := ( ::cID )->action
      wauxit     := ( ::cID )->auxit
      wimage     := ( ::cID )->image
      wtooltip   := ( ::cID )->tooltip
      wcheck     := ( ::cID )->check
      wautosize  := ( ::cID )->autosize
      wseparator := ( ::cID )->separator
      wgroup     := ( ::cID )->group
      wwhole     := ( ::cID )->whole
      wdrop      := ( ::cID )->drop

      ( ::cID )->( dbSkip() )
      ( ::cID )->item      := witem
      ( ::cID )->named     := wname
      ( ::cID )->action    := waction
      ( ::cID )->auxit     := wauxit
      ( ::cID )->image     := wimage
      ( ::cID )->tooltip   := wtooltip
      ( ::cID )->check     := wcheck
      ( ::cID )->autosize  := wautosize
      ( ::cID )->separator := wseparator
      ( ::cID )->group     := wgroup
      ( ::cID )->whole     := wwhole
      ( ::cID )->drop      := wdrop

      ( ::cID )->( dbSkip( -1 ) )
   ENDDO

   ( ::cID )->item      := ""
   ( ::cID )->named     := ""
   ( ::cID )->action    := ""
   ( ::cID )->auxit     := ""
   ( ::cID )->image     := ""
   ( ::cID )->tooltip   := ""
   ( ::cID )->check     := ""
   ( ::cID )->autosize  := ""
   ( ::cID )->separator := ""
   ( ::cID )->group     := ""
   ( ::cID )->whole     := ""
   ( ::cID )->drop      := ""

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()

   ::FormEdit:text_101:Value     := ""
   ::FormEdit:text_102:Value     := ""
   ::FormEdit:edit_101:Value     := ""
   ::FormEdit:text_103:Value     := ""
   ::FormEdit:text_5:Value       := ""
   ::FormEdit:text_6:Value       := ""
   ::FormEdit:text_7:Value       := ""
   ::FormEdit:checkbox_101:Value := .F.
   ::FormEdit:checkbox_102:Value := .F.
   ::FormEdit:checkbox_103:Value := .F.
   ::FormEdit:checkbox_104:Value := .F.
   ::FormEdit:checkbox_105:Value := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveDown() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, xitem, xname, xaction, xauxit, ximage, xtooltip, xcheck, xdrop
LOCAL xautosize, xseparator, xgroup, xwhole, witem, wname, waction, wauxit
LOCAL wimage, wtooltip, wcheck, wdrop, wautosize, wseparator, wgroup, wwhole

   nRegAux := ::FormEdit:browse_101:Value
   IF nRegAux == ( ::cID )->( RecCount() )
      PlayBeep()
      RETURN NIL
   ENDIF

   ( ::cID )->( dbGoTo( nRegAux ) )
   xitem      := ( ::cID )->item
   xname      := ( ::cID )->named
   xaction    := ( ::cID )->action
   xauxit     := ( ::cID )->auxit
   ximage     := ( ::cID )->image
   xtooltip   := ( ::cID )->tooltip
   xcheck     := ( ::cID )->check
   xautosize  := ( ::cID )->autosize
   xseparator := ( ::cID )->separator
   xgroup     := ( ::cID )->group
   xwhole     := ( ::cID )->whole
   xdrop      := ( ::cID )->drop

   ( ::cID )->( dbSkip() )
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wauxit     := ( ::cID )->auxit
   wimage     := ( ::cID )->image
   wtooltip   := ( ::cID )->tooltip
   wcheck     := ( ::cID )->check
   wautosize  := ( ::cID )->autosize
   wseparator := ( ::cID )->separator
   wgroup     := ( ::cID )->group
   wwhole     := ( ::cID )->whole
   wdrop      := ( ::cID )->drop

   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->auxit     := xauxit
   ( ::cID )->image     := ximage
   ( ::cID )->tooltip   := xtooltip
   ( ::cID )->check     := xcheck
   ( ::cID )->autosize  := xautosize
   ( ::cID )->separator := xseparator
   ( ::cID )->group     := xgroup
   ( ::cID )->whole     := xwhole
   ( ::cID )->drop      := xdrop

   ( ::cID )->( dbSkip( -1 ) )
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->auxit     := wauxit
   ( ::cID )->image     := wimage
   ( ::cID )->tooltip   := wtooltip
   ( ::cID )->check     := wcheck
   ( ::cID )->autosize  := wautosize
   ( ::cID )->separator := wseparator
   ( ::cID )->group     := wgroup
   ( ::cID )->whole     := wwhole
   ( ::cID )->drop      := wdrop

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := nRegAux + 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveUp() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, xitem, xname, xaction, xauxit, ximage, xtooltip, xcheck, xdrop
LOCAL xautosize, xseparator, xgroup, xwhole, witem, wname, waction, wauxit
LOCAL wimage, wtooltip, wcheck, wdrop, wautosize, wseparator, wgroup, wwhole

   nRegAux := ::FormEdit:browse_101:Value
   IF nRegAux == 1
      PlayBeep()
      RETURN NIL
   ENDIF

   ( ::cID )->( dbGoTo( nRegAux ) )
   xitem      := ( ::cID )->item
   xname      := ( ::cID )->named
   xaction    := ( ::cID )->action
   xauxit     := ( ::cID )->auxit
   ximage     := ( ::cID )->image
   xtooltip   := ( ::cID )->tooltip
   xcheck     := ( ::cID )->check
   xautosize  := ( ::cID )->autosize
   xseparator := ( ::cID )->separator
   xgroup     := ( ::cID )->group
   xwhole     := ( ::cID )->whole
   xdrop      := ( ::cID )->drop

   ( ::cID )->( dbSkip( -1 ) )
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wauxit     := ( ::cID )->auxit
   wimage     := ( ::cID )->image
   wtooltip   := ( ::cID )->tooltip
   wcheck     := ( ::cID )->check
   wautosize  := ( ::cID )->autosize
   wseparator := ( ::cID )->separator
   wgroup     := ( ::cID )->group
   wwhole     := ( ::cID )->whole
   wdrop      := ( ::cID )->drop

   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->auxit     := xauxit
   ( ::cID )->image     := ximage
   ( ::cID )->tooltip   := xtooltip
   ( ::cID )->check     := xcheck
   ( ::cID )->autosize  := xautosize
   ( ::cID )->separator := xseparator
   ( ::cID )->group     := xgroup
   ( ::cID )->whole     := xwhole
   ( ::cID )->drop      := xdrop

   ( ::cID )->( dbSkip() )
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->auxit     := wauxit
   ( ::cID )->image     := wimage
   ( ::cID )->tooltip   := wtooltip
   ( ::cID )->check     := wcheck
   ( ::cID )->autosize  := wautosize
   ( ::cID )->separator := wseparator
   ( ::cID )->group     := wgroup
   ( ::cID )->whole     := wwhole
   ( ::cID )->drop      := wdrop

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := nRegAux - 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD New( oEditor ) CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ::oEditor := oEditor
RETURN Self

//------------------------------------------------------------------------------
METHOD OpenWorkArea() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL aDbf[15][4]

   aDbf[01][ DBS_NAME ] := "Auxit"
   aDbf[01][ DBS_TYPE ] := "Character"
   aDbf[01][ DBS_LEN ]  := 200
   aDbf[01][ DBS_DEC ]  := 0

   aDbf[02][ DBS_NAME ] := "Item"
   aDbf[02][ DBS_TYPE ] := "Character"
   aDbf[02][ DBS_LEN ]  := 80
   aDbf[02][ DBS_DEC ]  := 0

   aDbf[03][ DBS_NAME ] := "Named"
   aDbf[03][ DBS_TYPE ] := "Character"
   aDbf[03][ DBS_LEN ]  := 40
   aDbf[03][ DBS_DEC ]  := 0

   aDbf[04][ DBS_NAME ] := "Action"
   aDbf[04][ DBS_TYPE ] := "Character"
   aDbf[04][ DBS_LEN ]  := 250
   aDbf[04][ DBS_DEC ]  := 0

   aDbf[05][ DBS_NAME ] := "Check"
   aDbf[05][ DBS_TYPE ] := "Character"
   aDbf[05][ DBS_LEN ]  := 1
   aDbf[05][ DBS_DEC ]  := 0

   aDbf[06][ DBS_NAME ] := "Autosize"
   aDbf[06][ DBS_TYPE ] := "Character"
   aDbf[06][ DBS_LEN ]  := 1
   aDbf[06][ DBS_DEC ]  := 0

   aDbf[07][ DBS_NAME ] := "Image"
   aDbf[07][ DBS_TYPE ] := "Character"
   aDbf[07][ DBS_LEN ]  := 40
   aDbf[07][ DBS_DEC ]  := 0

   aDbf[08][ DBS_NAME ] := "Separator"
   aDbf[08][ DBS_TYPE ] := "Character"
   aDbf[08][ DBS_LEN ]  := 1
   aDbf[08][ DBS_DEC ]  := 0

   aDbf[09][ DBS_NAME ] := "Group"
   aDbf[09][ DBS_TYPE ] := "Character"
   aDbf[09][ DBS_LEN ]  := 1
   aDbf[09][ DBS_DEC ]  := 0

   aDbf[10][ DBS_NAME ] := "Drop"
   aDbf[10][ DBS_TYPE ] := "Character"
   aDbf[10][ DBS_LEN ]  := 1
   aDbf[10][ DBS_DEC ]  := 0

   aDbf[11][ DBS_NAME ] := "Tooltip"
   aDbf[11][ DBS_TYPE ] := "Character"
   aDbf[11][ DBS_LEN ]  := 80
   aDbf[11][ DBS_DEC ]  := 0

   aDbf[12][ DBS_NAME ] := "Obj"
   aDbf[12][ DBS_TYPE ] := "Character"
   aDbf[12][ DBS_LEN ]  := 30
   aDbf[12][ DBS_DEC ]  := 0

   aDbf[13][ DBS_NAME ] := "Whole"
   aDbf[13][ DBS_TYPE ] := "Character"
   aDbf[13][ DBS_LEN ]  := 1
   aDbf[13][ DBS_DEC ]  := 0

   aDbf[14][ DBS_NAME ] := "Subclass"
   aDbf[14][ DBS_TYPE ] := "Character"
   aDbf[14][ DBS_LEN ]  := 30
   aDbf[14][ DBS_DEC ]  := 0

   aDbf[15][ DBS_NAME ] := "Auxit2"
   aDbf[15][ DBS_TYPE ] := "Character"
   aDbf[15][ DBS_LEN ]  := 200
   aDbf[15][ DBS_DEC ]  := 0

   ::cID := _OOHG_GetNullName( "0" )

   dbCreate( ::cID, aDbf, "DBFNTX" )

   dbUseArea( .T., NIL, ::cID, ::cID, .F., .F. )
   ( ::cID )->( __dbZap() )

   ::cTbFile := ::oEditor:cFName + '.tbr'
   IF File( ::cTbFile )
      ( ::cID )->( __dbApp( ::cTbFile ) )
      ( ::cID )->( __dbPack() )
      ( ::cID )->( dbGoTop() )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ParseData() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL i, nProps := 26, aPar := array( nProps ), wVar, nStart, nIndex

   ( ::cID )->( dbGoTop() )
   wVar  := AllTrim( ( ::cID )->auxit + ( ::cID )->auxit2 )
   IF Empty( wVar )
      wVar := 'toolbar_1,65,65,,.F.,.F.,.F.,.T.,Arial,10,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,.F.,.F.,,,,,.F.'
      // name,width,height,tooltip,flat,bottom,righttext,border,font,size,italic,bold,strikeout,underline,red,green,blue,vertical,break,rtl,notabstop,obj,caption,action,subclass,nobreak
   ENDIF
   nStart := 1
   nIndex := 1
   aFill( aPar, "" )
   FOR i := 1 TO Len( wVar )
      IF SubStr( wVar, i, 1 ) == ','
         aPar[nIndex] := AllTrim( SubStr( wVar, nStart, i - nStart ) )
         nStart := i + 1
         nIndex ++
         IF nIndex > nProps
            EXIT
         ENDIF
      ENDIF
   NEXT i
   IF nIndex <= nProps
      aPar[nIndex] := AllTrim( SubStr( wVar, nStart ) )
   ENDIF

   ::cTbName    := IIF( Empty( aPar[01] ), 'toolbar_1', aPar[01] )
   ::nWidth     := IIF( Val( aPar[02] ) > 0, Val( aPar[02] ), 65 )
   ::nHeight    := IIF( Val( aPar[03] ) > 0, Val( aPar[03] ), 65 )
   ::cToolTip   := aPar[04]
   ::lFlat      := ( aPar[05] == '.T.' )
   ::lBottom    := ( aPar[06] == '.T.' )
   ::lRightText := ( aPar[07] == '.T.' )
   ::lBorder    := ( aPar[08] == '.T.' )
   ::cFont      := aPar[09]
   ::nSize      := Val( aPar[10] )
   ::lItalic    := ( aPar[11] == '.T.' )
   ::lBold      := ( aPar[12] == '.T.' )
   ::lStrikeout := ( aPar[13] == '.T.' )
   ::lUnderline := ( aPar[14] == '.T.' )
   ::cColorR    := Val( aPar[15] )
   ::cColorG    := Val( aPar[16] )
   ::cColorB    := Val( aPar[17] )
   ::lVertical  := ( aPar[18] == '.T.' )
   ::lBreak     := ( aPar[19] == '.T.' )
   ::lRTL       := ( aPar[20] == '.T.' )
   ::lNoTabStop := ( aPar[21] == '.T.' )
   ::cObj       := aPar[22]
   ::cCaption   := aPar[23]
   ::cAction    := aPar[24]
   ::cSubclass  := aPar[25]
   ::lNoBreak   := ( aPar[26] == '.T.' )

   IF ::FormEdit # NIL
      ::FormEdit:text_1:Value     := ::cTbName
      ::FormEdit:text_2:Value     := ::nWidth
      ::FormEdit:text_3:Value     := ::nHeight
      ::FormEdit:text_4:Value     := ::cToolTip
      ::FormEdit:checkbox_1:Value := ::lFlat
      ::FormEdit:checkbox_2:Value := ::lBottom
      ::FormEdit:checkbox_3:Value := ::lRightText
      ::FormEdit:checkbox_4:Value := ::lBorder
      ::FormEdit:checkbox_5:Value := ::lVertical
      ::FormEdit:checkbox_6:Value := ::lRTL
      ::FormEdit:checkbox_7:Value := ::lNoTabStop
      ::FormEdit:checkbox_8:Value := ::lBreak
      ::FormEdit:checkbox_9:Value := ::lNoBreak
      ::FormEdit:browse_101:Value := 1
      ::FormEdit:text_8:Value     := ::cObj
      ::FormEdit:text_9:Value     := ::cCaption
      ::FormEdit:text_10:Value    := ::cAction
      ::FormEdit:text_11:Value    := ::cSubclass
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ParseItem() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ::FormEdit:text_101:Value     := AllTrim( ( ::cID )->item )
   ::FormEdit:text_102:Value     := AllTrim( ( ::cID )->named )
   ::FormEdit:edit_101:Value     := AllTrim( ( ::cID )->action )
   ::FormEdit:text_103:Value     := AllTrim( ( ::cID )->image )
   ::FormEdit:text_5:Value       := AllTrim( ( ::cID )->tooltip )
   ::FormEdit:text_6:Value       := AllTrim( ( ::cID )->obj )
   ::FormEdit:text_7:Value       := AllTrim( ( ::cID )->subclass )
   ::FormEdit:checkbox_101:Value := ( ( ::cID )->check == 'X' )
   ::FormEdit:checkbox_102:Value := ( ( ::cID )->autosize == 'X' )
   ::FormEdit:checkbox_103:Value := ( ( ::cID )->separator == 'X' )
   ::FormEdit:checkbox_104:Value := ( ( ::cID )->group == 'X' )
   ::FormEdit:checkbox_105:Value := ( ( ::cID )->whole == 'X' )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Save() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL wVar
                                                         // Length
   wVar := ::cTbName + ',' + ;                           //  30 + 1
           LTrim( Str( ::nWidth ) ) + ',' + ;            //   4 + 1
           LTrim( Str( ::nHeight ) ) + ',' + ;           //   4 + 1
           ::cToolTip + ',' + ;                          //  30 + 1
           IIF( ::lFlat, '.T.', '.F.' ) + ',' + ;        //   3 + 1
           IIF( ::lBottom, '.T.', '.F.' ) + ',' + ;      //   3 + 1
           IIF( ::lRightText, '.T.', '.F.' ) + ',' + ;   //   3 + 1
           IIF( ::lBorder, '.T.', '.F.' ) + ',' + ;      //   3 + 1
           ::cFont + ',' + ;                             //  31 + 1
           LTrim( Str( ::nSize ) ) + ',' + ;             //   3 + 1
           IIF( ::lItalic, '.T.', '.F.' ) + ',' + ;      //   3 + 1
           IIF( ::lBold, '.T.', '.F.' ) + ',' + ;        //   3 + 1
           IIF( ::lStrikeout, '.T.', '.F.' ) + ',' + ;   //   3 + 1
           IIF( ::lUnderline, '.T.', '.F.' ) + ',' + ;   //   3 + 1
           LTrim( Str( ::cColorR, 3 ) ) + ',' + ;        //   3 + 1
           LTrim( Str( ::cColorG, 3 ) ) + ',' + ;        //   3 + 1
           LTrim( Str( ::cColorB, 3 ) ) + ',' + ;        //   3 + 1
           IIF( ::lVertical, '.T.', '.F.' ) + ',' + ;    //   3 + 1
           IIF( ::lBreak, '.T.', '.F.' ) + ',' + ;       //   3 + 1
           IIF( ::lRTL, '.T.', '.F.' ) + ',' + ;         //   3 + 1
           IIF( ::lNoTabStop, '.T.', '.F.' ) + ',' + ;   //   3 + 1
           ::cObj + ',' + ;                              //  30 + 1
           ::cCaption + ',' + ;                          //  30 + 1
           ::cAction + ',' + ;                           //  30 + 1
           ::cSubclass + ',' + ;                         //  30 + 1
           IIF( ::lNoBreak, '.T.', '.F.' )               //   3
                                                         // 270 + 25
   ( ::cID )->( dbGoTop() )
   ( ::cID )->auxit  := SubStr(wVar, 1, Len( ( ::cID )->auxit ) )
   ( ::cID )->auxit2 := SubStr(wVar, Len( ( ::cID )->auxit ) + 1 )
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetFont() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
LOCAL aFont, cColor

   cColor := '{' + Str( ::cColorR, 3 ) + ',' + Str( ::cColorG, 3 ) + ',' + Str( ::cColorB, 3 ) + '}'
   aFont := GetFont( ::cFont, ::nSize, ::lBold, ::lItalic, &cColor, ::lUnderline, ::lStrikeout, 0 )
   IF aFont[1] == ""
      RETURN NIL
   ENDIF
   ::cFont      := aFont[1]
   ::nSize      := aFont[2]
   ::lBold      := aFont[3]
   ::lItalic    := aFont[4]
   ::cColorR    := aFont[5, 1]
   ::cColorG    := aFont[5, 2]
   ::cColorB    := aFont[5, 3]
   ::lUnderline := aFont[6]
   ::lStrikeout := aFont[7]
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteAction() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->action := AllTrim( ::FormEdit:edit_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteAutosize() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_102:Value
      ::FormEdit:checkbox_102:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->autosize := IIF( ::FormEdit:checkbox_102:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteCheck() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_101:Value
      ::FormEdit:checkbox_101:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->check := IIF( ::FormEdit:checkbox_101:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteGroup() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_104:Value
      ::FormEdit:checkbox_104:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->group := IIF( ::FormEdit:checkbox_104:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteImage() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->image := AllTrim( ::FormEdit:text_103:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteCaption() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->item := AllTrim( ::FormEdit:text_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteName() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->named := AllTrim( ::FormEdit:text_102:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteObj() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->obj := AllTrim( ::FormEdit:text_6:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteSeparator() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_103:Value
      ::FormEdit:checkbox_103:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->separator := IIF( ::FormEdit:checkbox_103:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteSubclass() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->subclass := AllTrim( ::FormEdit:text_7:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteToolTip() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->tooltip := AllTrim( ::FormEdit:text_5:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteWhole() CLASS TMyToolBarEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_105:Value
      ::FormEdit:checkbox_105:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   IF ::FormEdit:checkbox_105:Value
      ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
      IF ! File( ::oEditor:cFName + '.' + AllTrim( ( ::cID )->named ) + '.mnd' )
         ::FormEdit:checkbox_105:Value := .F.
         MsgStop( 'You must first define a dropdown menu for this item.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
   ENDIF
   ( ::cID )->whole := IIF( ::FormEdit:checkbox_105:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

/*
 * EOF
 */
