/*
 * $Id: menued.prg,v 1.6 2014-09-16 04:11:20 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2014 Ciro Vargas Clemov <cvc@oohg.org>
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

CLASS TMyMenuEditor
   DATA cID       INIT ''
   DATA cMnFile   INIT ''
   DATA FormEdit  INIT NIL
   DATA oEditor   INIT NIL
   DATA nLevel    INIT 0
   DATA nType     INIT 0

   METHOD AddItem
   METHOD CloseWorkArea
   METHOD CreateMenuCtrl
   METHOD CreateMenuFromFile
   METHOD DeleteItem
   METHOD Discard
   METHOD Edit
   METHOD Exit
   METHOD FmgOutput
   METHOD InsertItem
   METHOD MoveDown
   METHOD MoveUp
   METHOD OpenWorkArea
   METHOD ReadLevel
   METHOD SetLevel
   METHOD WriteAction
   METHOD WriteCaption
   METHOD WriteChecked
   METHOD WriteDisabled
   METHOD WriteImage
   METHOD WriteName

ENDCLASS

*------------------------------------------------------------------------------*
METHOD AddItem() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbAppend() )
   ::FormEdit:browse_101:Value := ( ::cID )->( RecCount() )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD CloseWorkArea() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL cFile

   ( ::cID )->( dbCloseArea() )
   cFile := ::cID + '.dbf'
   IF File( cFile )
      ERASE ( cFile )
   ENDIF
   ::nType := 0
RETURN NIL

*------------------------------------------------------------------------------*
METHOD CreateMenuCtrl() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL nNxtLvl, nLvl, nPopupCount := 0

   DO CASE
   CASE ::nType == 1
      IF HB_IsObject( ::oEditor:myMMCtrl )
         ::oEditor:myMMCtrl:Release()
      ENDIF

      DEFINE MAIN MENU OF ( ::oEditor:oDesignForm ) ;
         OBJ ::oEditor:myMMCtrl

         ( ::cID )->( dbGoTop() )
         DO WHILE ! ( ::cID )->( Eof() )
            ( ::cID )->( dbSkip() )
            IF ( ::cID )->( Eof() )
               nNxtLvl := 0
            ELSE
               nNxtLvl := ( ::cID )->level
            ENDIF

            ( ::cID )->( dbSkip( -1 ) )
            nLvl := ( ::cID )->level
            IF nNxtLvl > nLvl
               IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
                  SEPARATOR
               ELSE
                  IF ( ::cID )->checked == 'X'
                     IF ( ::cID )->enabled == 'X'
                        POPUP AllTrim( ( ::cID )->auxit ) CHECKED DISABLED
                     ELSE
                        POPUP AllTrim( ( ::cID )->auxit ) CHECKED
                     ENDIF
                  ELSE
                     IF ( ::cID )->enabled == 'X'
                        POPUP AllTrim( ( ::cID )->auxit ) DISABLED
                     ELSE
                        POPUP AllTrim( ( ::cID )->auxit )
                     ENDIF
                  ENDIF
                  nPopupCount ++
               ENDIF
            ELSE
               IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
                  SEPARATOR
               ELSE
                  // TODO: Add IMAGE
                  IF ( ::cID )->checked == 'X'
                     IF ( ::cID )->enabled == 'X'
                        ITEM AllTrim( ( ::cID )->auxit ) ACTION NIL CHECKED DISABLED
                     ELSE
                        ITEM AllTrim( ( ::cID )->auxit ) ACTION NIL CHECKED
                     ENDIF
                  ELSE
                     IF ( ::cID )->enabled == 'X'
                        ITEM AllTrim( ( ::cID )->auxit ) ACTION NIL DISABLED
                     ELSE
                        ITEM AllTrim( ( ::cID )->auxit ) ACTION NIL
                     ENDIF
                  ENDIF
               ENDIF

               DO WHILE nNxtLvl < nLvl
                  END POPUP
                  nPopupCount --
                  nLvl --
               ENDDO
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         DO WHILE nPopupCount > 0
            END POPUP
            nPopupCount --
         ENDDO
      END MENU
   CASE ::nType == 2
      IF HB_IsObject( ::oEditor:myCMCtrl )
         ::oEditor:myCMCtrl:Release()
      ENDIF
      /*
         TODO: Create item in context menu to show it
         See TODO in METHOD TForm1:Open.
      */
   CASE ::nType == 3
      IF HB_IsObject( ::oEditor:myNMCtrl )
         ::oEditor:myNMCtrl:Release()
      ENDIF
      /*
         TODO: Create item in context menu to show it
         See TODO in METHOD TForm1:Open.
      */
   CASE ::nType == 4
      IF HB_IsObject( ::oEditor:myDMCtrl )
         ::oEditor:myDMCtrl:Release()
      ENDIF
      /*
         TODO: Create control
         See METHOD CreateToolBarCtrl in toolbed.prg
      */
   ENDCASE
RETURN NIL

*------------------------------------------------------------------------------*
METHOD CreateMenuFromFile( oEditor, nType, cButton ) CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   IF HB_IsObject( oEditor )
      ::oEditor := oEditor
   ENDIF
   IF HB_IsNumeric( nType ) .AND. nType >= 1 .AND. nType <= 4
      ::nType := nType
   ENDIF

   ::OpenWorkArea( cButton )
   ::CreateMenuCtrl()
   ::CloseWorkArea()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD DeleteItem() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->( dbDelete() )
   ( ::cID )->( __dbPack() )
   ::FormEdit:browse_101:Value := 1
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD Discard() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ::FormEdit:Release()
   ::CloseWorkArea()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD Edit( oEditor, nType, cButton ) CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
Local cTitulo := {'Main', 'Context', 'Notify', 'Drop Down'}

   IF HB_IsObject( oEditor )
      ::oEditor := oEditor
   ENDIF
   IF HB_IsNumeric( nType ) .AND. nType >= 1 .AND. nType <= 4
      ::nType := nType
      ::OpenWorkArea( cButton )
      LOAD WINDOW myMenuEd AS ( ::cID )
      ::FormEdit := GetFormObject( ::cID )
      IF nType > 1
         ::FormEdit:button_104:Enabled := .F.
         ::FormEdit:button_105:Enabled := .F.
      ENDIF
      ::FormEdit:Title := 'ooHG IDE+ ' + cTitulo[nType] + ' menu editor'
      ON KEY ESCAPE OF ( ::cID ) ACTION ::FormEdit:Release()
      ACTIVATE WINDOW ( ::cID )
      ::oEditor:MisPuntos()
   ENDIF
RETURN NIL

*------------------------------------------------------------------------------*
METHOD Exit() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL cFile

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      IF ::nType == 1
         ::CreateMenuCtrl()
      ENDIF
      ::FormEdit:Release()
      ( ::cID )->( dbCloseArea() )
      cFile := ::cID + ".dbf"
      COPY FILE ( cFile ) TO ( ::cMnFile )
      ERASE ( cFile )
   ELSE
      IF HB_IsObject( ::oEditor:myMMCtrl )
         ::oEditor:myMMCtrl:Release()
      ENDIF
      ::FormEdit:Release()
      ( ::cID )->( dbCloseArea() )
      IF File( ::cMnFile )
         ERASE ( ::cMnFile )
      ENDIF
      ERASE ( ::cID + ".dbf" )
   ENDIF
   ::oEditor:lFSave := .F.
RETURN NIL

*------------------------------------------------------------------------------*
METHOD FmgOutput( oEditor, nType, nSpacing, cButton ) CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL Output := "", nNxtLvl, nLvl, nPopupCount := 0

   IF HB_IsObject( oEditor )
      ::oEditor := oEditor
   ENDIF
   IF HB_IsNumeric( nType ) .AND. nType >= 1 .AND. nType <= 4
      ::nType := nType
   ENDIF

   ::OpenWorkArea( cButton )

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      DO CASE
      CASE ::nType == 1
         Output += Space( nSpacing ) + 'DEFINE MAIN MENU '
         /*
            TODO: Add this properties
               [ OBJ <obj> ] ;
               [ SUBCLASS <subclass> ] ;
               [ NAME <name> ] ;
         */
         Output += CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            ( ::cID )->( dbSkip() )
            IF ( ::cID )->( Eof() )
               nNxtLvl := 0
            ELSE
               nNxtLvl := ( ::cID )->level
            ENDIF

            ( ::cID )->( dbSkip( -1 ) )
            nLvl := ( ::cID )->level
            IF nNxtLvl > nLvl
               IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  /*
                     TODO: Add this properties
                        [ OBJ <obj> ] ;
                        [ <right:RIGHT> ] ;
                        [ SUBCLASS <subclass> ] ;
                  */
                  Output += CRLF
               ELSE
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'POPUP ' + StrToStr( ( ::cID )->auxit )
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->image )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                  ENDIF
                  IF ( ::cID )->enabled == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
                  ENDIF
                  IF ( ::cID )->checked == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
                  ENDIF
                  /*
                     TODO: Add this properties
                        [ OBJ <obj> ] ;
                        [ <hilited:HILITED> ] ;
                        [ IMAGE <image> [ <stretch:STRETCH> ] ] ;
                        [ <right:RIGHT> ] ;
                        [ SUBCLASS <subclass> ] ;
                        [ <breakmenu :BREAKMENU> ] ;
                  */
                  Output += CRLF
                  nPopupCount ++
               ENDIF
            ELSE
               IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  /*
                     TODO: Add this properties
                        [ OBJ <obj> ] ;
                        [ <right:RIGHT> ] ;
                        [ SUBCLASS <subclass> ] ;
                  */
                  Output += CRLF
               ELSE
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->auxit )
                  IF Empty( ( ::cID )->action )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
                  ELSE
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
                  ENDIF
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->image )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                  ENDIF
                  IF ( ::cID )->enabled == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
                  ENDIF
                  IF ( ::cID )->checked == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
                  ENDIF
                  /*
                     TODO: Add this properties
                        [ IMAGE <image> [ <stretch:STRETCH> ] ] ;
                        [ OBJ <obj> ] ;
                        [ <hilited:HILITED> ] ;
                        [ <right:RIGHT> ] ;
                        [ SUBCLASS <subclass> ] ;
                        [ <breakmenu :BREAKMENU> ;
                  */
                  Output += CRLF
               ENDIF

               DO WHILE nNxtLvl < nLvl
                  Output += Space( nSpacing * ( nLvl + 1 ) ) + 'END POPUP ' + CRLF
                  nPopupCount --
                  nLvl --
               ENDDO
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         nLvl --
         DO WHILE nPopupCount > 0
            Output += Space( nSpacing * nLvl ) + 'END POPUP ' + CRLF
            nPopupCount --
            nLvl --
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      CASE ::nType == 2
         Output += Space( nSpacing ) + 'DEFINE CONTEXT MENU '
         /*
            TODO: Add this properties
               [ OBJ <obj> ] ;
               [ SUBCLASS <subclass> ] ;
               [ NAME <name> ] ;
         */
         Output += CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               /*
                  TODO: Add this properties
                     [ OBJ <obj> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
               */
               Output += CRLF
            ELSE
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->auxit )
               IF Empty( ( ::cID )->action )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
               ELSE
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
               ENDIF
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
               ENDIF
               /*
                  TODO: Add this properties
                     [ IMAGE <image> [ <stretch:STRETCH> ] ] ;
                     [ OBJ <obj> ] ;
                     [ <hilited:HILITED> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
                     [ <breakmenu :BREAKMENU> ;
               */
               Output += CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      CASE ::nType == 3
         Output += Space( nSpacing ) + 'DEFINE NOTIFY MENU '
         /*
            TODO: Add this properties
               [ OBJ <obj> ] ;
               [ SUBCLASS <subclass> ] ;
               [ NAME <name> ] ;
         */
         Output += CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               /*
                  TODO: Add this properties
                     [ OBJ <obj> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
               */
               Output += CRLF
            ELSE
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->auxit )
               IF Empty( ( ::cID )->action )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
               ELSE
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
               ENDIF
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
               ENDIF
               /*
                  TODO: Add this properties
                     [ IMAGE <image> [ <stretch:STRETCH> ] ] ;
                     [ OBJ <obj> ] ;
                     [ <hilited:HILITED> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
                     [ <breakmenu :BREAKMENU> ;
               */
               Output += CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      CASE ::nType == 4
         Output += Space( nSpacing ) + 'DEFINE DROPDOWN MENU BUTTON ' + cbutton
         /*
            TODO: Add this properties
               [ OBJ <obj> ] ;
               [ SUBCLASS <subclass> ] ;
               [ NAME <name> ] ;
         */
         Output += CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->auxit ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               /*
                  TODO: Add this properties
                     [ OBJ <obj> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
               */
               Output += CRLF
            ELSE

               Output += Space( nSpacing * ( ( ::cID )->level + 1 ) ) + 'ITEM ' + StrToStr( ( ::cID )->auxit )
               Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ACTION ' + IIF( Len( AllTrim( ( ::cID )->action ) ) # 0, AllTrim( ( ::cID )->action ), "MsgBox( 'item' )" )
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'NAME ' + AllTrim( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'CHECKED '
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'DISABLED '
               ENDIF
               /*
                  TODO: Add this properties
                     [ IMAGE <image> [ <stretch:STRETCH> ] ] ;
                     [ OBJ <obj> ] ;
                     [ <hilited:HILITED> ] ;
                     [ <right:RIGHT> ] ;
                     [ SUBCLASS <subclass> ] ;
                     [ <breakmenu :BREAKMENU> ;
               */
               Output += CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      ENDCASE
   ENDIF

   ::CloseWorkArea()
RETURN Output

*------------------------------------------------------------------------------*
METHOD InsertItem() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL nRegAux, witem, wname, waction, wauxit, wimage, wlevel, wlev

   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   nRegAux := ( ::cID )->( RecNo() )

   ( ::cID )->( dbAppend() )

   DO WHILE ( ::cID )->( RecNo() ) > nRegAux
      ( ::cID )->( dbSkip( -1 ) )
      witem      := ( ::cID )->item
      wname      := ( ::cID )->named
      waction    := ( ::cID )->action
      wauxit     := ( ::cID )->auxit
      wlevel     := ( ::cID )->level
      wimage     := ( ::cID )->image
      wlev       := ( ::cID )->lev

      ( ::cID )->( dbSkip() )
      ( ::cID )->item      := witem
      ( ::cID )->named     := wname
      ( ::cID )->action    := waction
      ( ::cID )->auxit     := wauxit
      ( ::cID )->level     := wlevel
      ( ::cID )->image     := wimage
      ( ::cID )->lev       := wlev

      ( ::cID )->( dbSkip( -1 ) )
   ENDDO

   ( ::cID )->item      := ""
   ( ::cID )->named     := ""
   ( ::cID )->action    := ""
   ( ::cID )->auxit     := ""
   ( ::cID )->level     := ""
   ( ::cID )->image     := ""
   ( ::cID )->lev       := ""

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()

   ::FormEdit:text_101:Value     := ""
   ::FormEdit:text_102:Value     := ""
   ::FormEdit:text_103:Value     := ""
   ::FormEdit:edit_101:Value     := ""
   ::FormEdit:checkbox_101:Value := .F.
   ::FormEdit:checkbox_102:Value := .F.
RETURN NIL

*------------------------------------------------------------------------------*
METHOD MoveDown() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL nRegAux, xitem, xname, xaction, xauxit, xlevel, ximage, xenabled, xchecked
LOCAL xlev, witem, wname, waction, wauxit, wlevel, wimage, wenabled, wchecked
LOCAL wlev

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
   xlevel     := ( ::cID )->level
   ximage     := ( ::cID )->image
   xenabled   := ( ::cID )->enabled
   xchecked   := ( ::cID )->checked
   xlev       := ( ::cID )->lev

   ( ::cID )->( dbSkip() )
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wauxit     := ( ::cID )->auxit
   wlevel     := ( ::cID )->level
   wimage     := ( ::cID )->image
   wenabled   := ( ::cID )->enabled
   wchecked   := ( ::cID )->checked
   wlev       := ( ::cID )->lev

   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->auxit     := xauxit
   ( ::cID )->level     := xlevel
   ( ::cID )->image     := ximage
   ( ::cID )->enabled   := xenabled
   ( ::cID )->checked   := xchecked
   ( ::cID )->lev       := xlev

   ( ::cID )->( dbSkip( -1 ) )
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->auxit     := wauxit
   ( ::cID )->level     := wlevel
   ( ::cID )->image     := wimage
   ( ::cID )->enabled   := wenabled
   ( ::cID )->checked   := wchecked
   ( ::cID )->lev       := wlev

   ::FormEdit:browse_101:Value := nRegAux + 1
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD MoveUp() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL nRegAux, xitem, xname, xaction, xauxit, xlevel, ximage, xenabled, xchecked
LOCAL xlev, witem, wname, waction, wauxit, wlevel, wimage, wenabled, wchecked
LOCAL wlev

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
   xlevel     := ( ::cID )->level
   ximage     := ( ::cID )->image
   xenabled   := ( ::cID )->enabled
   xchecked   := ( ::cID )->checked
   xlev       := ( ::cID )->lev

   ( ::cID )->( dbSkip( -1 ) )
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wauxit     := ( ::cID )->auxit
   wlevel     := ( ::cID )->level
   wimage     := ( ::cID )->image
   wenabled   := ( ::cID )->enabled
   wchecked   := ( ::cID )->checked
   wlev       := ( ::cID )->lev

   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->auxit     := xauxit
   ( ::cID )->level     := xlevel
   ( ::cID )->image     := ximage
   ( ::cID )->enabled   := xenabled
   ( ::cID )->checked   := xchecked
   ( ::cID )->lev       := xlev

   ( ::cID )->( dbSkip() )
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->auxit     := wauxit
   ( ::cID )->level     := wlevel
   ( ::cID )->image     := wimage
   ( ::cID )->enabled   := wenabled
   ( ::cID )->checked   := wchecked
   ( ::cID )->lev       := wlev

   ::FormEdit:browse_101:Value := nRegAux - 1
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD OpenWorkArea( cButton ) CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
LOCAL aDbf[9][4]

   aDbf[1][ DBS_NAME ] := "Auxit"
   aDbf[1][ DBS_TYPE ] := "Character"
   aDbf[1][ DBS_LEN ]  := 200
   aDbf[1][ DBS_DEC ]  := 0

   aDbf[2][ DBS_NAME ] := "Item"
   aDbf[2][ DBS_TYPE ] := "Character"
   aDbf[2][ DBS_LEN ]  := 80
   aDbf[2][ DBS_DEC ]  := 0

   aDbf[3][ DBS_NAME ] := "Named"
   aDbf[3][ DBS_TYPE ] := "Character"
   aDbf[3][ DBS_LEN ]  := 40
   aDbf[3][ DBS_DEC ]  := 0

   aDbf[4][ DBS_NAME ] := "Action"
   aDbf[4][ DBS_TYPE ] := "Character"
   aDbf[4][ DBS_LEN ]  := 250
   aDbf[4][ DBS_DEC ]  := 0

   aDbf[5][ DBS_NAME ] := "Level"
   aDbf[5][ DBS_TYPE ] := "numeric"
   aDbf[5][ DBS_LEN ]  := 1
   aDbf[5][ DBS_DEC ]  := 0

   aDbf[6][ DBS_NAME ] := "Checked"
   aDbf[6][ DBS_TYPE ] := "Character"
   aDbf[6][ DBS_LEN ]  := 1
   aDbf[6][ DBS_DEC ]  := 0

   aDbf[7][ DBS_NAME ] := "Enabled"
   aDbf[7][ DBS_TYPE ] := "Character"
   aDbf[7][ DBS_LEN ]  := 1
   aDbf[7][ DBS_DEC ]  := 0

   aDbf[8][ DBS_NAME ] := "Lev"
   aDbf[8][ DBS_TYPE ] := "Character"
   aDbf[8][ DBS_LEN ]  := 1
   aDbf[8][ DBS_DEC ]  := 0

   aDbf[9][ DBS_NAME ] := "Image"
   aDbf[9][ DBS_TYPE ] := "Character"
   aDbf[9][ DBS_LEN ]  := 40
   aDbf[9][ DBS_DEC ]  := 0

   ::cID := _OOHG_GetNullName( "0" )

   dbCreate( ::cID, aDbf, "DBFNTX" )

   dbUseArea( .T., NIL, ::cID, ::cID, .F., .F. )
   ( ::cID )->( __dbZap() )

   DO CASE
   CASE ::nType == 1
      ::cMnFile := ::oEditor:cFName + '.mnm'
   CASE ::nType == 2
      ::cMnFile := ::oEditor:cFName + '.mnc'
   CASE ::nType == 3
      ::cMnFile := ::oEditor:cFName + '.mnn'
   CASE ::nType == 4
      ::cMnFile := ::oEditor:cFName + '.' + AllTrim( cButton ) + '.mnd'
   OTHERWISE
      RETURN NIL
   ENDCASE

   IF File( ::cMnFile )
      ( ::cID )->( __dbApp( ::cMnFile ) )
      ( ::cID )->( __dbPack() )
      ( ::cID )->( dbGoTop() )
   ENDIF
RETURN NIL

*------------------------------------------------------------------------------*
METHOD ReadLevel() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ::FormEdit:text_101:Value     := AllTrim( ( ::cID )->item )
   ::FormEdit:text_102:Value     := ( ::cID )->named
   ::FormEdit:edit_101:Value     := ( ::cID )->action
   ::FormEdit:text_103:Value     := ( ::cID )->image
   ::FormEdit:checkbox_101:Value := ( ( ::cID )->checked == 'X' )
   ::FormEdit:checkbox_102:Value := ( ( ::cID )->enabled == 'X' )
   ::nLevel                      := ( ::cID )->level
RETURN NIL

*------------------------------------------------------------------------------*
METHOD SetLevel() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->item := Space( ::nLevel * 3 ) + AllTrim( ( ::cID )->item )
   ( ::cID )->level := ::nLevel
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteAction() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->action := AllTrim( ::FormEdit:edit_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteCaption() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->item := Space( ::nLevel * 3 ) + AllTrim( ::FormEdit:text_101:Value )
   ( ::cID )->auxit := AllTrim( ::FormEdit:text_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteChecked() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_101:Value
      ::FormEdit:checkbox_101:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->checked := IIF( ::FormEdit:checkbox_101:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteDisabled() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_102:Value
      ::FormEdit:checkbox_102:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->enabled := IIF( ::FormEdit:checkbox_102:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteImage() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->image := AllTrim( ::FormEdit:text_103:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD WriteName() CLASS TMyMenuEditor
*------------------------------------------------------------------------------*
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->named := AllTrim( ::FormEdit:text_102:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL
