/*
 * $Id: menued.prg,v 1.10 2014-09-19 23:07:10 fyurisich Exp $
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
   DATA cMnName   INIT ''
   DATA cObj      INIT ''
   DATA cSubclass INIT ''
   DATA FormEdit  INIT NIL
   DATA nLevel    INIT 0
   DATA nType     INIT 0
   DATA oEditor   INIT NIL

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
   METHOD ParseData
   METHOD ParseItem
   METHOD Save
   METHOD WriteAction
   METHOD WriteBreakMenu
   METHOD WriteCaption
   METHOD WriteChecked
   METHOD WriteDisabled
   METHOD WriteHilited
   METHOD WriteImage
   METHOD WriteLevel
   METHOD WriteName
   METHOD WriteObj
   METHOD WriteRight
   METHOD WriteStretch
   METHOD WriteSubclass

ENDCLASS

//------------------------------------------------------------------------------
METHOD AddItem() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbAppend() )
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := ( ::cID )->( RecCount() )
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CloseWorkArea() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL cFile

   ( ::cID )->( dbCloseArea() )
   cFile := ::cID + '.dbf'
   IF File( cFile )
      ERASE ( cFile )
   ENDIF
   ::nType := 0
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateMenuCtrl( oButton ) CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL nNxtLvl, nLvl, nPopupCount := 0, oItem

   DO CASE
   CASE ::nType == 1
      IF HB_IsObject( ::oEditor:myMMCtrl )
         ::oEditor:myMMCtrl:Release()
         ::oEditor:myMMCtrl := NIL
      ENDIF

      ( ::cID )->( dbGoTop() )
      IF ! ( ::cID )->( Eof() )
         DEFINE MAIN MENU OF ( ::oEditor:oDesignForm ) ;
            OBJ ::oEditor:myMMCtrl

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
                  IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                     SEPARATOR
                  ELSE
                     oItem := TMenuItem():DefinePopUp( AllTrim( ( ::cID )->item ), ;
                                 NIL, ;
                                 ( ::cID )->checked == 'X', ;
                                 ( ::cID )->enabled == 'X', ;
                                 NIL, ;
                                 ( ::cID )->hilited == 'X', ;
                                 AllTrim( ( ::cID )->image ), ;
                                 ( ::cID )->right == 'X', ;
                                 ( ::cID )->stretch == 'X', ;
                                 IIF( ( ::cID )->breakmenu == 'X', 1, NIL ) )
                     nPopupCount ++
                  ENDIF
               ELSE
                  IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                     oItem := TMenuItem():DefineSeparator( NIL, NIL, ( ::cID )->right == 'X' )
                  ELSE
                     oItem := TMenuItem():DefineItem( AllTrim( ( ::cID )->item ), ;
                                 NIL, ;
                                 NIL, ;
                                 AllTrim( ( ::cID )->image ), ;
                                 ( ::cID )->checked == 'X', ;
                                 ( ::cID )->enabled == 'X', ;
                                 NIL, ;
                                 ( ::cID )->hilited == 'X', ;
                                 ( ::cID )->right == 'X', ;
                                 ( ::cID )->stretch == 'X', ;
                                 IIF( ( ::cID )->breakmenu == 'X', 1, NIL ) )
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
      ENDIF
   CASE ::nType == 2
      IF HB_IsObject( ::oEditor:myCMCtrl )
         ::oEditor:myCMCtrl:Release()
         ::oEditor:myCMCtrl := NIL
      ENDIF

      ( ::cID )->( dbGoTop() )
      IF ! ( ::cID )->( Eof() )
         DEFINE MENU DYNAMIC OF ( ::oEditor:oDesignForm ) ;
            OBJ ::oEditor:myCMCtrl

            DO WHILE ! ( ::cID )->( Eof() )
               IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                  oItem := TMenuItem():DefineSeparator( NIL, NIL, ( ::cID )->right == 'X' )
               ELSE
                  oItem := TMenuItem():DefineItem( AllTrim( ( ::cID )->item ), ;
                              NIL, ;
                              NIL, ;
                              AllTrim( ( ::cID )->image ), ;
                              ( ::cID )->checked == 'X', ;
                              ( ::cID )->enabled == 'X', ;
                              NIL, ;
                              ( ::cID )->hilited == 'X', ;
                              ( ::cID )->right == 'X', ;
                              ( ::cID )->stretch == 'X', ;
                              IIF( ( ::cID )->breakmenu == 'X', 1, NIL ) )
               ENDIF

               ( ::cID )->( dbSkip() )
            ENDDO
         END MENU
      ENDIF
   CASE ::nType == 3
      IF HB_IsObject( ::oEditor:myNMCtrl )
         ::oEditor:myNMCtrl:Release()
         ::oEditor:myNMCtrl := NIL
      ENDIF

      ( ::cID )->( dbGoTop() )
      IF ! ( ::cID )->( Eof() )
         DEFINE MENU DYNAMIC OF ( ::oEditor:oDesignForm ) ;
            OBJ ::oEditor:myNMCtrl

            DO WHILE ! ( ::cID )->( Eof() )
               IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                  oItem := TMenuItem():DefineSeparator( NIL, NIL, ( ::cID )->right == 'X' )
               ELSE
                  oItem := TMenuItem():DefineItem( AllTrim( ( ::cID )->item ), ;
                              NIL, ;
                              NIL, ;
                              AllTrim( ( ::cID )->image ), ;
                              ( ::cID )->checked == 'X', ;
                              ( ::cID )->enabled == 'X', ;
                              NIL, ;
                              ( ::cID )->hilited == 'X', ;
                              ( ::cID )->right == 'X', ;
                              ( ::cID )->stretch == 'X', ;
                              IIF( ( ::cID )->breakmenu == 'X', 1, NIL ) )
               ENDIF

               ( ::cID )->( dbSkip() )
            ENDDO
         END MENU
      ENDIF

   CASE ::nType == 4
      IF HB_IsObject( ::oEditor:myDMCtrl )
         ::oEditor:myDMCtrl:Release()
         ::oEditor:myDMCtrl := NIL
      ENDIF

      ( ::cID )->( dbGoTop() )
      IF ! ( ::cID )->( Eof() )
         DEFINE DROPDOWN MENU BUTTON ( oButton ) ;
            OBJ ::oEditor:myDMCtrl

            DO WHILE ! ( ::cID )->( Eof() )
               IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                  oItem := TMenuItem():DefineSeparator( NIL, NIL, ( ::cID )->right == 'X' )
               ELSE
                  oItem := TMenuItem():DefineItem( AllTrim( ( ::cID )->item ), ;
                              NIL, ;
                              NIL, ;
                              AllTrim( ( ::cID )->image ), ;
                              ( ::cID )->checked == 'X', ;
                              ( ::cID )->enabled == 'X', ;
                              NIL, ;
                              ( ::cID )->hilited == 'X', ;
                              ( ::cID )->right == 'X', ;
                              ( ::cID )->stretch == 'X', ;
                              IIF( ( ::cID )->breakmenu == 'X', 1, NIL ) )
               ENDIF

               ( ::cID )->( dbSkip() )
            ENDDO
         END MENU
      ENDIF
   ENDCASE
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateMenuFromFile( oEditor, nType, cButton, oButton ) CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   IF HB_IsObject( oEditor )
      ::oEditor := oEditor
   ENDIF
   IF HB_IsNumeric( nType ) .AND. nType >= 1 .AND. nType <= 4
      ::nType := nType
   ENDIF

   ::OpenWorkArea( cButton )
   ::ParseData()
   ::CreateMenuCtrl( oButton )
   ::CloseWorkArea()
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteItem() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->( dbDelete() )
   ( ::cID )->( __dbPack() )
   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Discard() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ::FormEdit:Release()
   ::FormEdit := NIL
   ::CloseWorkArea()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit( oEditor, nType, cButton ) CLASS TMyMenuEditor
//------------------------------------------------------------------------------
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
      IF ( ::cID )->( RecCount() ) > 0
         ::FormEdit:browse_101:Value := 1
      ENDIF
      ON KEY ESCAPE OF ( ::cID ) ACTION ::FormEdit:Release()
      ::ParseData()
      ACTIVATE WINDOW ( ::cID )
      ::FormEdit := NIL
      ::oEditor:MisPuntos()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL cFile

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      ::Save()
      IF ::nType >= 1 .and. ::nType <= 3
         ::CreateMenuCtrl()
      ENDIF
      ::FormEdit:Release()
      ::FormEdit := NIL
      ( ::cID )->( dbCloseArea() )
      cFile := ::cID + ".dbf"
      COPY FILE ( cFile ) TO ( ::cMnFile )
      ERASE ( cFile )
   ELSE
      IF HB_IsObject( ::oEditor:myMMCtrl )
         ::oEditor:myMMCtrl:Release()
         ::oEditor:myMMCtrl := NIL
      ENDIF
      ::FormEdit:Release()
      ::FormEdit := NIL
      ( ::cID )->( dbCloseArea() )
      IF File( ::cMnFile )
         ERASE ( ::cMnFile )
      ENDIF
      ERASE ( ::cID + ".dbf" )
   ENDIF
   ::oEditor:lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD FmgOutput( oEditor, nType, nSpacing, cButton ) CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL Output := "", nNxtLvl, nLvl, nPopupCount := 0

   IF HB_IsObject( oEditor )
      ::oEditor := oEditor
   ENDIF
   IF HB_IsNumeric( nType ) .AND. nType >= 1 .AND. nType <= 4
      ::nType := nType
   ENDIF

   ::OpenWorkArea( cButton )
   ::ParseData()

   ( ::cID )->( dbGoTop() )
   IF ! ( ::cID )->( Eof() )
      DO CASE
      CASE ::nType == 1
         Output += Space( nSpacing ) + 'DEFINE MAIN MENU '
         IF ! Empty( ::cMnName )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'NAME ' + AllTrim( ::cMnName )
         ENDIF
         IF ! Empty( ::cObj )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'OBJ ' + AllTrim( ::cObj )
         ENDIF
         IF ! Empty( ::cSubclass )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SUBCLASS ' + AllTrim( ::cSubclass )
         ENDIF
         Output += CRLF + CRLF

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
               IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->obj )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
                  ENDIF
                  IF ! Empty( ( ::cID )->subclass )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
                  ENDIF
                  IF ( ::cID )->right == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
                  ENDIF
                  Output += CRLF + CRLF
               ELSE
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'POPUP ' + StrToStr( ( ::cID )->item )
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->obj )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
                  ENDIF
                  IF ! Empty( ( ::cID )->subclass )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
                  ENDIF
                  IF ! Empty( ( ::cID )->image )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                     IF ( ::cID )->stretch == 'X'
                        Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'STRETCH '
                     ENDIF
                  ENDIF
                  IF ( ::cID )->enabled == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
                  ENDIF
                  IF ( ::cID )->checked == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
                  ENDIF
                  IF ( ::cID )->hilited == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'HILITED '
                  ENDIF
                  IF ( ::cID )->right == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
                  ENDIF
                  IF ( ::cID )->breakmenu == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'BREAKMENU '
                  ENDIF
                  Output += CRLF + CRLF

                  nPopupCount ++
               ENDIF
            ELSE
               IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->obj )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
                  ENDIF
                  IF ! Empty( ( ::cID )->subclass )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
                  ENDIF
                  IF ( ::cID )->right == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
                  ENDIF
                  Output += CRLF + CRLF
               ELSE
                  Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->item )
                  IF ! Empty( ( ::cID )->named )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
                  ENDIF
                  IF ! Empty( ( ::cID )->obj )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
                  ENDIF
                  IF ! Empty( ( ::cID )->subclass )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
                  ENDIF
                  IF Empty( ( ::cID )->action )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
                  ELSE
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
                  ENDIF
                  IF ! Empty( ( ::cID )->image )
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                     IF ( ::cID )->stretch == 'X'
                        Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'STRETCH '
                     ENDIF
                  ENDIF
                  IF ( ::cID )->enabled == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
                  ENDIF
                  IF ( ::cID )->checked == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
                  ENDIF
                  IF ( ::cID )->hilited == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'HILITED '
                  ENDIF
                  IF ( ::cID )->right == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
                  ENDIF
                  IF ( ::cID )->breakmenu == "X"
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'BREAKMENU '
                  ENDIF
                  Output += CRLF + CRLF
               ENDIF

               DO WHILE nNxtLvl < nLvl
                  Output += Space( nSpacing * ( nLvl + 1 ) ) + 'END POPUP '
                  Output += CRLF + CRLF
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
         IF ! Empty( ::cMnName )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'NAME ' + AllTrim( ::cMnName )
         ENDIF
         IF ! Empty( ::cObj )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'OBJ ' + AllTrim( ::cObj )
         ENDIF
         IF ! Empty( ::cSubclass )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SUBCLASS ' + AllTrim( ::cSubclass )
         ENDIF
         Output += CRLF + CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               Output += CRLF + CRLF
            ELSE
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->item )
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF Empty( ( ::cID )->action )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
               ELSE
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                  IF ( ::cID )->stretch == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'STRETCH '
                  ENDIF
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
               ENDIF
               IF ( ::cID )->hilited == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'HILITED '
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               IF ( ::cID )->breakmenu == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'BREAKMENU '
               ENDIF
               Output += CRLF + CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      CASE ::nType == 3
         Output += Space( nSpacing ) + 'DEFINE NOTIFY MENU '
         IF ! Empty( ::cMnName )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'NAME ' + AllTrim( ::cMnName )
         ENDIF
         IF ! Empty( ::cObj )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'OBJ ' + AllTrim( ::cObj )
         ENDIF
         IF ! Empty( ::cSubclass )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SUBCLASS ' + AllTrim( ::cSubclass )
         ENDIF
         Output += CRLF + CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               Output += CRLF + CRLF
            ELSE
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->item )
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF Empty( ( ::cID )->action )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
               ELSE
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                  IF ( ::cID )->stretch == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'STRETCH '
                  ENDIF
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
               ENDIF
               IF ( ::cID )->hilited == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'HILITED '
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               IF ( ::cID )->breakmenu == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'BREAKMENU '
               ENDIF
               Output += CRLF + CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      CASE ::nType == 4
         Output += Space( nSpacing ) + 'DEFINE DROPDOWN MENU BUTTON ' + cButton
         IF ! Empty( ::cMnName )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'NAME ' + AllTrim( ::cMnName )
         ENDIF
         IF ! Empty( ::cObj )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'OBJ ' + AllTrim( ::cObj )
         ENDIF
         IF ! Empty( ::cSubclass )
            Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SUBCLASS ' + AllTrim( ::cSubclass )
         ENDIF
         Output += CRLF + CRLF

         DO WHILE ! ( ::cID )->( Eof() )
            IF Lower( AllTrim( ( ::cID )->item ) ) == 'separator'
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'SEPARATOR '
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               Output += CRLF + CRLF
            ELSE
               Output += Space( nSpacing * ( ( ::cID )->level + 2 ) ) + 'ITEM ' + StrToStr( ( ::cID )->item )
               IF ! Empty( ( ::cID )->named )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'NAME ' + StrToStr( ( ::cID )->named )
               ENDIF
               IF ! Empty( ( ::cID )->obj )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'OBJ ' + AllTrim( ( ::cID )->obj )
               ENDIF
               IF ! Empty( ( ::cID )->subclass )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'SUBCLASS ' + AllTrim( ( ::cID )->subclass )
               ENDIF
               IF Empty( ( ::cID )->action )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + "MsgBox( 'item' )"
               ELSE
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'ACTION ' + AllTrim( ( ::cID )->action )
               ENDIF
               IF ! Empty( ( ::cID )->image )
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'IMAGE ' + StrToStr( ( ::cID )->image )
                  IF ( ::cID )->stretch == 'X'
                     Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'STRETCH '
                  ENDIF
               ENDIF
               IF ( ::cID )->enabled == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'DISABLED '
               ENDIF
               IF ( ::cID )->checked == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'CHECKED '
               ENDIF
               IF ( ::cID )->hilited == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'HILITED '
               ENDIF
               IF ( ::cID )->right == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'RIGHT '
               ENDIF
               IF ( ::cID )->breakmenu == "X"
                  Output += ' ;' + CRLF + Space( nSpacing * ( ( ::cID )->level + 3 ) ) + 'BREAKMENU '
               ENDIF
               Output += CRLF + CRLF
            ENDIF

            ( ::cID )->( dbSkip() )
         ENDDO

         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      ENDCASE
   ENDIF

   ::CloseWorkArea()
RETURN Output

//------------------------------------------------------------------------------
METHOD InsertItem() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, wauxit, witem, wname, waction, wlevel, wchecked, wenabled
LOCAL wimage, wobj, wstretch, whilited, wright, wbreakmenu, wsubclass

   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   nRegAux := ( ::cID )->( RecNo() )

   ( ::cID )->( dbAppend() )

   DO WHILE ( ::cID )->( RecNo() ) > nRegAux
      ( ::cID )->( dbSkip( -1 ) )
      wauxit     := ( ::cID )->auxit
      witem      := ( ::cID )->item
      wname      := ( ::cID )->named
      waction    := ( ::cID )->action
      wlevel     := ( ::cID )->level
      wchecked   := ( ::cID )->checked
      wenabled   := ( ::cID )->enabled
      wimage     := ( ::cID )->image
      wobj       := ( ::cID )->obj
      wstretch   := ( ::cID )->stretch
      whilited   := ( ::cID )->hilited
      wright     := ( ::cID )->right
      wbreakmenu := ( ::cID )->breakmenu
      wsubclass  := ( ::cID )->subclass

      ( ::cID )->( dbSkip() )
      ( ::cID )->auxit     := wauxit
      ( ::cID )->item      := witem
      ( ::cID )->named     := wname
      ( ::cID )->action    := waction
      ( ::cID )->level     := wlevel
      ( ::cID )->checked   := wchecked
      ( ::cID )->enabled   := wenabled
      ( ::cID )->image     := wimage
      ( ::cID )->obj       := wobj
      ( ::cID )->stretch   := wstretch
      ( ::cID )->hilited   := whilited
      ( ::cID )->right     := wright
      ( ::cID )->breakmenu := wbreakmenu
      ( ::cID )->subclass  := wsubclass

      ( ::cID )->( dbSkip( -1 ) )
   ENDDO

   ( ::cID )->auxit     := ""
   ( ::cID )->item      := ""
   ( ::cID )->named     := ""
   ( ::cID )->action    := ""
   ( ::cID )->level     := 0
   ( ::cID )->checked   := ""
   ( ::cID )->enabled   := ""
   ( ::cID )->image     := ""
   ( ::cID )->obj       := ""
   ( ::cID )->stretch   := ""
   ( ::cID )->hilited   := ""
   ( ::cID )->right     := ""
   ( ::cID )->breakmenu := ""
   ( ::cID )->subclass  := ""

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:SetFocus()

   ::FormEdit:text_101:Value     := ""
   ::FormEdit:text_102:Value     := ""
   ::FormEdit:edit_101:Value     := ""
   ::FormEdit:text_103:Value     := ""
   ::FormEdit:text_5:Value       := ""
   ::FormEdit:text_6:Value       := ""
   ::FormEdit:checkbox_101:Value := .F.
   ::FormEdit:checkbox_102:Value := .F.
   ::FormEdit:checkbox_103:Value := .F.
   ::FormEdit:checkbox_104:Value := .F.
   ::FormEdit:checkbox_105:Value := .F.
   ::FormEdit:checkbox_106:Value := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveDown() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, xauxit, xitem, xname, xaction, xlevel, xchecked, xenabled
LOCAL ximage, xobj, xstretch, xhilited, xright, xbreakmenu, xsubclass
LOCAL wauxit, witem, wname, waction, wlevel, wchecked, wenabled, wimage
LOCAL wobj, wstretch, whilited, wright, wbreakmenu, wsubclass

   nRegAux := ::FormEdit:browse_101:Value
   IF nRegAux == ( ::cID )->( RecCount() )
      PlayBeep()
      RETURN NIL
   ENDIF

   ( ::cID )->( dbGoTo( nRegAux ) )
   xauxit     := ( ::cID )->auxit
   xitem      := ( ::cID )->item
   xname      := ( ::cID )->named
   xaction    := ( ::cID )->action
   xlevel     := ( ::cID )->level
   xchecked   := ( ::cID )->checked
   xenabled   := ( ::cID )->enabled
   ximage     := ( ::cID )->image
   xobj       := ( ::cID )->obj
   xstretch   := ( ::cID )->stretch
   xhilited   := ( ::cID )->hilited
   xright     := ( ::cID )->right
   xbreakmenu := ( ::cID )->breakmenu
   xsubclass  := ( ::cID )->subclass

   ( ::cID )->( dbSkip() )
   wauxit     := ( ::cID )->auxit
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wlevel     := ( ::cID )->level
   wchecked   := ( ::cID )->checked
   wenabled   := ( ::cID )->enabled
   wimage     := ( ::cID )->image
   wobj       := ( ::cID )->obj
   wstretch   := ( ::cID )->stretch
   whilited   := ( ::cID )->hilited
   wright     := ( ::cID )->right
   wbreakmenu := ( ::cID )->breakmenu
   wsubclass  := ( ::cID )->subclass

   ( ::cID )->auxit     := xauxit
   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->level     := xlevel
   ( ::cID )->checked   := xchecked
   ( ::cID )->enabled   := xenabled
   ( ::cID )->image     := ximage
   ( ::cID )->obj       := xobj
   ( ::cID )->stretch   := xstretch
   ( ::cID )->hilited   := xhilited
   ( ::cID )->right     := xright
   ( ::cID )->breakmenu := xbreakmenu
   ( ::cID )->subclass  := xsubclass

   ( ::cID )->( dbSkip( -1 ) )
   ( ::cID )->auxit     := wauxit
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->level     := wlevel
   ( ::cID )->checked   := wchecked
   ( ::cID )->enabled   := wenabled
   ( ::cID )->image     := wimage
   ( ::cID )->obj       := wobj
   ( ::cID )->stretch   := wstretch
   ( ::cID )->hilited   := whilited
   ( ::cID )->right     := wright
   ( ::cID )->breakmenu := wbreakmenu
   ( ::cID )->subclass  := wsubclass

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := nRegAux + 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveUp() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL nRegAux, xauxit, xitem, xname, xaction, xlevel, xchecked, xenabled
LOCAL ximage, xobj, xstretch, xhilited, xright, xbreakmenu, xsubclass
LOCAL wauxit, witem, wname, waction, wlevel, wchecked, wenabled, wimage
LOCAL wobj, wstretch, whilited, wright, wbreakmenu, wsubclass

   nRegAux := ::FormEdit:browse_101:Value
   IF nRegAux == 1
      PlayBeep()
      RETURN NIL
   ENDIF

   ( ::cID )->( dbGoTo( nRegAux ) )
   xauxit     := ( ::cID )->auxit
   xitem      := ( ::cID )->item
   xname      := ( ::cID )->named
   xaction    := ( ::cID )->action
   xlevel     := ( ::cID )->level
   xchecked   := ( ::cID )->checked
   xenabled   := ( ::cID )->enabled
   ximage     := ( ::cID )->image
   xobj       := ( ::cID )->obj
   xstretch   := ( ::cID )->stretch
   xhilited   := ( ::cID )->hilited
   xright     := ( ::cID )->right
   xbreakmenu := ( ::cID )->breakmenu
   xsubclass  := ( ::cID )->subclass

   ( ::cID )->( dbSkip( -1 ) )
   wauxit     := ( ::cID )->auxit
   witem      := ( ::cID )->item
   wname      := ( ::cID )->named
   waction    := ( ::cID )->action
   wlevel     := ( ::cID )->level
   wchecked   := ( ::cID )->checked
   wenabled   := ( ::cID )->enabled
   wimage     := ( ::cID )->image
   wobj       := ( ::cID )->obj
   wstretch   := ( ::cID )->stretch
   whilited   := ( ::cID )->hilited
   wright     := ( ::cID )->right
   wbreakmenu := ( ::cID )->breakmenu
   wsubclass  := ( ::cID )->subclass

   ( ::cID )->auxit     := xauxit
   ( ::cID )->item      := xitem
   ( ::cID )->named     := xname
   ( ::cID )->action    := xaction
   ( ::cID )->level     := xlevel
   ( ::cID )->checked   := xchecked
   ( ::cID )->enabled   := xenabled
   ( ::cID )->image     := ximage
   ( ::cID )->obj       := xobj
   ( ::cID )->stretch   := xstretch
   ( ::cID )->hilited   := xhilited
   ( ::cID )->right     := xright
   ( ::cID )->breakmenu := xbreakmenu
   ( ::cID )->subclass  := xsubclass

   ( ::cID )->( dbSkip() )
   ( ::cID )->auxit     := wauxit
   ( ::cID )->item      := witem
   ( ::cID )->named     := wname
   ( ::cID )->action    := waction
   ( ::cID )->level     := wlevel
   ( ::cID )->checked   := wchecked
   ( ::cID )->enabled   := wenabled
   ( ::cID )->image     := wimage
   ( ::cID )->obj       := wobj
   ( ::cID )->stretch   := wstretch
   ( ::cID )->hilited   := whilited
   ( ::cID )->right     := wright
   ( ::cID )->breakmenu := wbreakmenu
   ( ::cID )->subclass  := wsubclass

   ::FormEdit:browse_101:Refresh()
   ::FormEdit:browse_101:Value := nRegAux - 1
   ::FormEdit:browse_101:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD OpenWorkArea( cButton ) CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL aDbf[14][4]

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

   aDbf[05][ DBS_NAME ] := "Level"
   aDbf[05][ DBS_TYPE ] := "numeric"
   aDbf[05][ DBS_LEN ]  := 1
   aDbf[05][ DBS_DEC ]  := 0

   aDbf[06][ DBS_NAME ] := "Checked"
   aDbf[06][ DBS_TYPE ] := "Character"
   aDbf[06][ DBS_LEN ]  := 1
   aDbf[06][ DBS_DEC ]  := 0

   aDbf[07][ DBS_NAME ] := "Enabled"
   aDbf[07][ DBS_TYPE ] := "Character"
   aDbf[07][ DBS_LEN ]  := 1
   aDbf[07][ DBS_DEC ]  := 0

   aDbf[08][ DBS_NAME ] := "Image"
   aDbf[08][ DBS_TYPE ] := "Character"
   aDbf[08][ DBS_LEN ]  := 40
   aDbf[08][ DBS_DEC ]  := 0

   aDbf[09][ DBS_NAME ] := "Obj"
   aDbf[09][ DBS_TYPE ] := "Character"
   aDbf[09][ DBS_LEN ]  := 40
   aDbf[09][ DBS_DEC ]  := 0

   aDbf[10][ DBS_NAME ] := "Stretch"
   aDbf[10][ DBS_TYPE ] := "Character"
   aDbf[10][ DBS_LEN ]  := 1
   aDbf[10][ DBS_DEC ]  := 0

   aDbf[11][ DBS_NAME ] := "Hilited"
   aDbf[11][ DBS_TYPE ] := "Character"
   aDbf[11][ DBS_LEN ]  := 1
   aDbf[11][ DBS_DEC ]  := 0

   aDbf[12][ DBS_NAME ] := "Right"
   aDbf[12][ DBS_TYPE ] := "Character"
   aDbf[12][ DBS_LEN ]  := 1
   aDbf[12][ DBS_DEC ]  := 0

   aDbf[13][ DBS_NAME ] := "BreakMenu"
   aDbf[13][ DBS_TYPE ] := "Character"
   aDbf[13][ DBS_LEN ]  := 1
   aDbf[13][ DBS_DEC ]  := 0

   aDbf[14][ DBS_NAME ] := "Subclass"
   aDbf[14][ DBS_TYPE ] := "Character"
   aDbf[14][ DBS_LEN ]  := 40
   aDbf[14][ DBS_DEC ]  := 0

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

//------------------------------------------------------------------------------
METHOD ParseData() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL i, nProps := 3, aPar := array( nProps ), wVar, nStart, nIndex

   ( ::cID )->( dbGoTop() )
   wVar  := AllTrim( ( ::cID )->auxit )
   IF Empty( wVar )
      wVar := ',,'
      // name,obj,subclass
   ELSEIF ! ',' $ wVar
      // this is a hack to correctly process old version files which
      // store the item name in auxit field and in item field
      wVar := ',,'
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

   ::cMnName    := aPar[01]
   ::cObj       := aPar[02]
   ::cSubclass  := aPar[03]

   IF ::FormEdit # NIL
      ::FormEdit:text_1:Value     := ::cMnName
      ::FormEdit:text_2:Value     := ::cObj
      ::FormEdit:text_3:Value     := ::cSubclass
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ParseItem() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ::nLevel                      := ( ::cID )->level
   ::FormEdit:text_101:Value     := AllTrim( ( ::cID )->item )
   ::FormEdit:text_102:Value     := ( ::cID )->named
   ::FormEdit:edit_101:Value     := ( ::cID )->action
   ::FormEdit:text_103:Value     := ( ::cID )->image
   ::FormEdit:text_5:Value       := ( ::cID )->obj
   ::FormEdit:text_6:Value       := ( ::cID )->subclass
   ::FormEdit:checkbox_101:Value := ( ( ::cID )->checked == 'X' )
   ::FormEdit:checkbox_102:Value := ( ( ::cID )->enabled == 'X' )
   ::FormEdit:checkbox_103:Value := ( ( ::cID )->right == 'X' )
   ::FormEdit:checkbox_104:Value := ( ( ::cID )->breakmenu == 'X' )
   ::FormEdit:checkbox_105:Value := ( ( ::cID )->stretch == 'X' )
   ::FormEdit:checkbox_106:Value := ( ( ::cID )->hilited == 'X' )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Save() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
LOCAL wVar
                                                         // Length
   wVar := ::cMnName + ',' + ;                           //  30 + 1
           ::cObj + ',' + ;                              //  30 + 1
           ::cSubclass                                   //  30
                                                         //  90 + 2
   ( ::cID )->( dbGoTop() )
   ( ::cID )->auxit  := SubStr(wVar, 1, Len( ( ::cID )->auxit ) )
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteAction() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->action := AllTrim( ::FormEdit:edit_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteBreakMenu() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->breakmenu := IIF( ::FormEdit:checkbox_104:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteCaption() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->item := Space( ::nLevel * 3 ) + AllTrim( ::FormEdit:text_101:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteChecked() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_101:Value
      ::FormEdit:checkbox_101:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->checked := IIF( ::FormEdit:checkbox_101:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteDisabled() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_102:Value ) .AND. ::FormEdit:checkbox_102:Value
      ::FormEdit:checkbox_102:Value := .F.
      MsgStop( 'You must first define a name for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->enabled := IIF( ::FormEdit:checkbox_102:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteHilited() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->hilited := IIF( ::FormEdit:checkbox_106:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteImage() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->image := AllTrim( ::FormEdit:text_103:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteLevel() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->item := Space( ::nLevel * 3 ) + AllTrim( ( ::cID )->item )
   ( ::cID )->level := ::nLevel
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteName() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->named := AllTrim( ::FormEdit:text_102:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteObj() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->obj := AllTrim( ::FormEdit:text_5:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteRight() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->right := IIF( ::FormEdit:checkbox_103:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteSubclass() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->subclass := AllTrim( ::FormEdit:text_6:Value )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

//------------------------------------------------------------------------------
METHOD WriteStretch() CLASS TMyMenuEditor
//------------------------------------------------------------------------------
   IF Empty( ::FormEdit:text_103:Value ) .AND. ::FormEdit:checkbox_105:Value
      ::FormEdit:checkbox_105:Value := .F.
      MsgStop( 'You must first define an image for this item.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF
   ( ::cID )->( dbGoTo( ::FormEdit:browse_101:Value ) )
   ( ::cID )->stretch := IIF( ::FormEdit:checkbox_105:Value, 'X', ' ' )
   ::FormEdit:browse_101:Refresh()
RETURN NIL

/*
 * EOF
 */
