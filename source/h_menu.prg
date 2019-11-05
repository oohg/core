/*
 * $Id: h_menu.prg $
 */
/*
 * ooHG source code:
 * Menu controls
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


#include "hbclass.ch"
#include "oohg.ch"
#include "i_windefs.ch"
#include "i_init.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuParams

   DATA aMenuParams                    INIT _OOHG_DefaultMenuParams
   DATA lOwnerDraw                     INIT _OOHG_OwnerDrawMenus
   DATA Type                           INIT "MENUPARAMS"

   METHOD Border3D                     SETGET
   METHOD Colors                       SETGET
   METHOD CursorType                   SETGET
   METHOD Gradient                     SETGET
   METHOD OwnerDraw                    SETGET
   METHOD Params                       SETGET
   METHOD SeparatorType                SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Border3D( lValue ) CLASS TMenuParams

   IF HB_ISLOGICAL( lValue )
      ::aMenuParams[ MNUBOR_IS3D ] := iif( lValue, 1, 0 )
   ENDIF

   RETURN ::aMenuParams[ MNUBOR_IS3D ] == 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Colors( aNewColors ) CLASS TMenuParams

   LOCAL i, nLen

   IF HB_ISARRAY( aNewColors )
      nLen := Min( Len( aNewColors ), MNUCLR_COUNT )
      FOR i := 1 TO nLen
         IF aNewColors[ i ] # NIL
            ::aMenuParams[ i ] := aNewColors[ i ]
         ENDIF
      NEXT i
   ENDIF

   RETURN ASize( AClone( ::aMenuParams ), MNUCLR_COUNT )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CursorType( nSize ) CLASS TMenuParams

   IF HB_ISNUMERIC( nSize )
      IF nSize == MNUCUR_FULL
         ::aMenuParams[ MNUCUR_SIZE ] := MNUCUR_FULL
      ELSEIF nSize == MNUCUR_SHORT
         ::aMenuParams[ MNUCUR_SIZE ] := MNUCUR_SHORT
      ENDIF
   ENDIF

   RETURN ::aMenuParams[ MNUCUR_SIZE ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Gradient( lValue ) CLASS TMenuParams

   IF HB_ISLOGICAL( lValue )
      ::aMenuParams[ MNUGRADIENT ] := iif( lValue, 1, 0 )
   ENDIF

   RETURN ::aMenuParams[ MNUGRADIENT ] == 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OwnerDraw( lValue ) CLASS TMenuParams

   IF HB_ISLOGICAL( lValue )
      ::lOwnerDraw := lValue
   ENDIF

   RETURN ::lOwnerDraw

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Params( aNewParams ) CLASS TMenuParams

   LOCAL i, nLen

   IF HB_ISARRAY( aNewParams )
      nLen := Min( Len( aNewParams ), MNUPAR_COUNT )
      FOR i := 1 TO nLen
         IF aNewParams[ i ] # NIL
            ::aMenuParams[ i ] := aNewParams[ i ]
         ENDIF
      NEXT i
   ENDIF

   RETURN ASize( AClone( ::aMenuParams ), MNUPAR_COUNT )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SeparatorType( nType ) CLASS TMenuParams

   IF HB_ISNUMERIC( nType )
      IF nType == MNUSEP_SINGLE
         ::aMenuParams[ MNUSEP_TYPE ] := MNUSEP_SINGLE
      ELSEIF nType == MNUSEP_DOUBLE
         ::aMenuParams[ MNUSEP_TYPE ] := MNUSEP_DOUBLE
      ENDIF
   ENDIF

   RETURN ::aMenuParams[ MNUSEP_TYPE ]


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenu FROM TControl

   DATA bOnInitPopUp                   INIT NIL
   DATA cFontID                        INIT NIL
   DATA cStatMsg                       INIT NIL
   DATA nTimeout                       INIT NIL
   DATA oMenuParams                    INIT NIL
   DATA lAdjust                        INIT .F.
   DATA lMain                          INIT .F.
   DATA Type                           INIT "MENU" READONLY

   METHOD Activate
   METHOD Border3D                     SETGET
   METHOD Colors                       SETGET
   METHOD CursorType                   SETGET
   METHOD Define
   METHOD DisableVisualStyle
   METHOD Enabled                      SETGET
   METHOD EndMenu
   METHOD Events_InitMenuPopUp( nPos ) BLOCK { |Self, nPos| _OOHG_EVAL( ::bOnInitPopUp, Self, nPos ) }
   METHOD Gradient                     SETGET
   METHOD ItemCount                    BLOCK { |Self| GetMenuItemCount( ::hWnd ) }
   METHOD ItemPosition( nItemId )      BLOCK { |Self, nItemId| FindItemPosition( ::hWnd, nItemId ) }
   METHOD OwnerDraw                    SETGET
   METHOD Params                       SETGET
   METHOD PopUpPosition( hWndPopUp )   BLOCK { |Self, hWndPopUp| FindPopUpPosition( ::hWnd, hWndPopUp ) }
   METHOD Refresh
   METHOD Release                      BLOCK { |Self| DestroyMenu( ::hWnd ), ::oMenuParams := NIL, ::Super:Release() }
   METHOD Separator                    BLOCK { |Self| TMenuItem():DefineSeparator( NIL, Self ) }
   METHOD SeparatorType                SETGET
   METHOD SetMenuBarColor

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw ) CLASS TMenu

   ::SetForm( cName, uParent )
   ::Container := NIL
   ::Register( CreatePopUpMenu() )
   ::oMenuParams := TMenuParams()
   ::OwnerDraw   := lOwnerDraw
   ::cStatMsg    := cMsg
   ::cFontId     := cFontId
   ::nTimeout    := nTimeout
   _OOHG_AppObject():ActiveMenuPush( Self )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TMenu

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      aEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::lEnabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DisableVisualStyle() CLASS TMenu

   IF ::IsVisualStyled
      ::Parent:DisableVisualStyle()
      IF ! ::Parent:IsVisualStyled
         ::lVisualStyled := .F.
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Activate( nRow, nCol ) CLASS TMenu

   LOCAL aPos

   aPos := GetCursorPos()
   ASSIGN aPos[ 1 ] VALUE nRow TYPE "N"
   ASSIGN aPos[ 2 ] VALUE nCol TYPE "N"
   TrackPopupMenu( ::hWnd, aPos[ 2 ], aPos[ 1 ], ::Parent:hWnd )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndMenu() CLASS TMenu

   _OOHG_AppObject():ActiveMenuRemove( Self )
   ::Refresh()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Refresh() CLASS TMenu

   IF ::lMain
      DrawMenuBar( ::Parent:hWnd )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Border3D( lValue ) CLASS TMenu

    RETURN ::oMenuParams:Border3D( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Colors( aNewColors ) CLASS TMenu

   RETURN ::oMenuParams:Colors( aNewColors )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CursorType( nSize ) CLASS TMenu

   RETURN ::oMenuParams:CursorType( nSize )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Gradient( lValue ) CLASS TMenu

   RETURN ::oMenuParams:Gradient( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OwnerDraw( lValue ) CLASS TMenu

   RETURN ::oMenuParams:OwnerDraw( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Params( aNewParams ) CLASS TMenu

   LOCAL uRet

   uRet := ::oMenuParams:Params( aNewParams )
   ::Refresh()

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SeparatorType( nType ) CLASS TMenu

   RETURN ::oMenuParams:SeparatorType( nType )


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuMain FROM TMenu

   DATA lMain                          INIT .T.

   METHOD Activate                     BLOCK { || NIL }
   METHOD Define
   METHOD Release                      BLOCK { |Self| ::Parent:oMenu := NIL, ::Super:Release() }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw, uColor, lApplyToSubMenus ) CLASS TMenuMain

   ::SetForm( cName, uParent )
   ::Container := NIL
   ::Register( CreateMenu() )
   ::oMenuParams := TMenuParams()
   ::OwnerDraw := lOwnerDraw
   ::cStatMsg  := cMsg
   ::cFontId   := cFontId
   ::nTimeout  := nTimeout
   _OOHG_AppObject():ActiveMenuPush( Self )

   IF ::Parent:oMenu != NIL
      // MAIN MENU already defined for this window
      ::Parent:oMenu:Release()
   ENDIF
   SetMenu( ::Parent:hWnd, ::hWnd )
   ::Parent:oMenu := Self

   IF ValType( uColor ) $ "ANB"
      ASSIGN lApplyToSubMenus VALUE lApplyToSubMenus TYPE "L" DEFAULT .T.
      ::SetMenuBarColor( uColor, lApplyToSubMenus )
   ENDIF

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuContext FROM TMenu

   METHOD Define
   METHOD Release                      BLOCK { |Self| ::Parent:ContextMenu := NIL, ::Super:Release() }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw ) CLASS TMenuContext

   ::Super:Define( uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw )
   IF ::Parent:ContextMenu != NIL
      ::Parent:ContextMenu:Release()
   ENDIF
   ::Parent:ContextMenu := Self

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuNotify FROM TMenu

   METHOD Define
   METHOD Release                      BLOCK { |Self| ::Parent:NotifyMenu := NIL, ::Super:Release() }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( Parent, Name, cMsg, cFontId, nTimeout, lOwnerDraw ) CLASS TMenuNotify

   ::Super:Define( Parent, Name, cMsg, cFontId, nTimeout, lOwnerDraw )
   IF ::Parent:NotifyMenu != NIL
      ::Parent:NotifyMenu:Release()
   ENDIF
   ::Parent:NotifyMenu := Self

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuDropDown FROM TMenu

   METHOD Define
   METHOD Release

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uButton, uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw ) CLASS TMenuDropDown

   LOCAL oContainer

   IF HB_ISOBJECT( uButton )
      uParent := uButton:Parent
      uButton := uButton:Name
   ENDIF
   ::Super:Define( uParent, cName, cMsg, cFontId, nTimeout, lOwnerDraw )
   oContainer := GetControlObject( uButton, ::Parent:Name )
   IF oContainer:ContextMenu != NIL
      oContainer:ContextMenu:Release()
   ENDIF
   oContainer:ContextMenu := Self

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TMenuDropDown

   IF ::Container != NIL
      ::Container:ContextMenu := NIL
   ENDIF

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndMenu()

   LOCAL oActiveMenu := _OOHG_AppObject():ActiveMenuGet()

   IF oActiveMenu # NIL
     oActiveMenu:EndMenu()
   ENDIF

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuItem FROM TControl

   DATA aPicture                       INIT { "", "" }
   DATA bOnInitPopUp                   INIT NIL
   DATA cCaption                       INIT NIL
   DATA cFontID                        INIT NIL
   DATA cStatMsg                       INIT NIL
   DATA hBitMaps                       INIT { NIL, NIL }
   DATA hExternFont                    INIT NIL
   DATA lAdjust                        INIT .F.
   DATA lIsAtBar                       INIT .F.
   DATA lIsMenuBreak                   INIT .F.
   DATA lIsPopUp                       INIT .F.
   DATA lIsSeparator                   INIT .F.
   DATA lMain                          INIT .F.
   DATA lOwnerDraw                     INIT .F.
   DATA lStretch                       INIT .F.
   DATA nTimeout                       INIT NIL
   DATA oMenuParams                    INIT NIL
   DATA Type                           INIT "MENUITEM" READONLY
   DATA xData                          INIT NIL

   METHOD Border3D                     SETGET
   METHOD Caption                      SETGET
   METHOD Checked                      SETGET
   METHOD Colors                       SETGET
   METHOD CursorType                   SETGET
   METHOD DefaultItem( nItem )         BLOCK { |Self, nItem| SetMenuDefaultItem( ::Container:hWnd, nItem ) }   // one-based position or 0 for no default
   METHOD DefaultItemById              BLOCK { |Self| SetMenuDefaultItemById( ::Container:hWnd, ::Id ) }
   METHOD DefineItem
   METHOD DefinePopUp
   METHOD DefineSeparator
   METHOD DoEvent
   METHOD Enabled                      SETGET
   METHOD EndPopUp
   METHOD Events_DrawItem
   METHOD Events_InitMenuPopUp
   METHOD Events_MeasureItem
   METHOD Events_MenuHilited
   METHOD Gradient                     SETGET
   METHOD Hilited                      SETGET
   METHOD InsertItem
   METHOD InsertPopUp
   METHOD InsertSeparator
   METHOD OwnerDraw                    SETGET
   METHOD Picture                      SETGET
   METHOD Position
   METHOD Release
   METHOD Separator                    BLOCK { |Self| TMenuItem():DefineSeparator( NIL, Self ) }
   METHOD SeparatorType                SETGET
   METHOD SetItemsColor
   METHOD Stretch                      SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefinePopUp( cCaption, cName, lChecked, lDisabled, uParent, lHilited, uImage, ;
                    lRight, lStretch, nBreak, cMsg, cFontId, bOnInitPopUp, nTimeout ) CLASS TMenuItem

   LOCAL nStyle, nId, hFont := NIL

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::OwnerDraw          := uParent:OwnerDraw
      ::lIsAtBar           := ( uParent:Type == "MENU" .AND. uParent:lMain )
      DEFAULT cMsg     TO uParent:cStatMsg
      DEFAULT cFontID  TO uParent:cFontID
      DEFAULT nTimeout TO uParent:nTimeout
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()
   ::Register( CreatePopupMenu(), cName, NIL, NIL, NIL, nId )
   _OOHG_AppObject():ActiveMenuPush( Self )

   ::lIsPopUp := .T.
   nStyle := MF_POPUP
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   IF HB_ISNUMERIC( nBreak )
      IF nBreak == 1
         nStyle += MF_MENUBREAK
         ::lIsMenuBreak := .T.
      ELSE
         nStyle += MF_MENUBARBREAK
      ENDIF
   ENDIF
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      IF ValidHandler( cFontId )
         ::hExternFont := cFontId
         ::cFontId := cFontId
      ELSEIF HB_ISSTRING( cFontId )
         IF ! Empty( cFontId ) .AND. ValidHandler( hFont := GetFontHandle( cFontId ) )
            ::hExternFont := hFont
            ::cFontId := cFontId
         ENDIF
      ELSEIF HB_ISARRAY( cFontId )
         ASize( cFontId, 11 )
         ::hExternFont := ::SetFont( cFontId[ 1 ], cFontId[ 2 ], cFontId[ 3 ], cFontId[ 4 ], cFontId[ 5 ], cFontId[ 6 ], ;
                                     cFontId[ 7 ], cFontId[ 8 ], cFontId[ 9 ], cFontId[ 10 ], cFontId[ 11 ] )
         ::cFontId := cFontId
      ENDIF
      ::cCaption := cCaption
      ::xData := CreateMenuItemData( ::Id )
      AppendMenu( ::Container:hWnd, ::hWnd, ::xData, nStyle )
   ELSE
      nStyle += MF_STRING
      AppendMenu( ::Container:hWnd, ::hWnd, cCaption, nStyle )
   ENDIF

   IF HB_ISLOGICAL( lStretch ) .AND. lStretch
      ::Stretch := .T.
   ENDIF
   ::Picture := uImage
   ::Checked := lChecked
   ::Hilited := lHilited
   IF HB_ISLOGICAL( lDisabled ) .AND. lDisabled
      ::Enabled := .F.
   ENDIF
   ASSIGN ::nTimeout     VALUE nTimeout     TYPE "N"
   ASSIGN ::cStatMsg     VALUE cMsg         TYPE "CM"
   ASSIGN ::bOnInitPopUp VALUE bOnInitPopUp TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertPopUp( cCaption, cName, lChecked, lDisabled, uParent, lHilited, uImage, ;
                    lRight, lStretch, nBreak, nPos, cMsg, cFontId, bOnInitPopUp, nTimeout ) CLASS TMenuItem

   LOCAL nStyle, nID, hFont := NIL

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::OwnerDraw          := uParent:OwnerDraw
      ::lIsAtBar           := ( uParent:Type == "MENU" .AND. uParent:lMain )
      DEFAULT cMsg     TO uParent:cStatMsg
      DEFAULT cFontID  TO uParent:cFontID
      DEFAULT nTimeout TO uParent:nTimeout
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()
   ::Register( CreatePopupMenu(), cName, NIL, NIL, NIL, nId )
   _OOHG_AppObject():ActiveMenuPush( Self )

   ::lIsPopUp := .T.
   nStyle := MF_POPUP + MF_BYPOSITION
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   IF HB_ISNUMERIC( nBreak )
      IF nBreak == 1
         nStyle += MF_MENUBREAK
         ::lIsMenuBreak := .T.
      ELSE
         nStyle += MF_MENUBARBREAK
      ENDIF
   ENDIF
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // Append to the end
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      IF ValidHandler( cFontId )
         ::hExternFont := cFontId
         ::cFontId := cFontId
      ELSEIF HB_ISSTRING( cFontId )
         IF ! Empty( cFontId ) .AND. ValidHandler( hFont := GetFontHandle( cFontId ) )
            ::hExternFont := hFont
            ::cFontId := cFontId
         ENDIF
      ELSEIF HB_ISARRAY( cFontId )
         ASize( cFontId, 11 )
         ::hExternFont := ::SetFont( cFontId[ 1 ], cFontId[ 2 ], cFontId[ 3 ], cFontId[ 4 ], cFontId[ 5 ], cFontId[ 6 ], ;
                                     cFontId[ 7 ], cFontId[ 8 ], cFontId[ 9 ], cFontId[ 10 ], cFontId[ 11 ] )
         ::cFontId := cFontId
      ENDIF
      ::cCaption := cCaption
      ::xData := CreateMenuItemData( ::Id )
      InsertMenu( ::Container:hWnd, ::hWnd, ::xData, nStyle, nPos )
   ELSE
      nStyle += MF_STRING
      InsertMenu( ::Container:hWnd, ::hWnd, cCaption, nStyle, nPos )
   ENDIF

   IF HB_ISLOGICAL( lStretch ) .AND. lStretch
      ::Stretch := .T.
   ENDIF
   ::Picture := uImage
   ::Checked := lChecked
   ::Hilited := lHilited
   IF HB_ISLOGICAL( lDisabled ) .AND. lDisabled
      ::Enabled := .F.
   ENDIF
   ASSIGN ::nTimeout     VALUE nTimeout     TYPE "N"
   ASSIGN ::cStatMsg     VALUE cMsg         TYPE "CM"
   ASSIGN ::bOnInitPopUp VALUE bOnInitPopUp TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineItem( cCaption, bAction, cName, uImage, lChecked, lDisabled, uParent, lHilited, ;
                   lRight, lStretch, nBreak, cMsg, lDefault, cFontId, nTimeout ) CLASS TMenuItem

   LOCAL nStyle, nId, hFont := NIL

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::OwnerDraw          := uParent:OwnerDraw
      ::lIsAtBar           := ( uParent:Type == "MENU" .AND. uParent:lMain )
      DEFAULT cMsg     TO uParent:cStatMsg
      DEFAULT cFontID  TO uParent:cFontID
      DEFAULT nTimeout TO uParent:nTimeout
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()

   nStyle := 0
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   IF HB_ISNUMERIC( nBreak )
      IF nBreak == 1
         nStyle += MF_MENUBREAK
         ::lIsMenuBreak := .T.
      ELSE
         nStyle += MF_MENUBARBREAK
      ENDIF
   ENDIF
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      IF ValidHandler( cFontId )
         ::hExternFont := cFontId
         ::cFontId := cFontId
      ELSEIF HB_ISSTRING( cFontId )
         IF ! Empty( cFontId ) .AND. ValidHandler( hFont := GetFontHandle( cFontId ) )
            ::hExternFont := hFont
            ::cFontId := cFontId
         ENDIF
      ELSEIF HB_ISARRAY( cFontId )
         ASize( cFontId, 11 )
         ::hExternFont := ::SetFont( cFontId[ 1 ], cFontId[ 2 ], cFontId[ 3 ], cFontId[ 4 ], cFontId[ 5 ], cFontId[ 6 ], ;
                                     cFontId[ 7 ], cFontId[ 8 ], cFontId[ 9 ], cFontId[ 10 ], cFontId[ 11 ] )
         ::cFontId := cFontId
      ENDIF
      ::cCaption := cCaption
      ::xData := CreateMenuItemData( nId )
      AppendMenu( ::Container:hWnd, nId, ::xData, nStyle )
   ELSE
      nStyle += MF_STRING
      AppendMenu( ::Container:hWnd, nId, cCaption, nStyle )
   ENDIF
   ::Register( 0, cName, NIL, NIL, NIL, nId )

   ASSIGN ::OnClick VALUE bAction TYPE "B"
   IF HB_ISLOGICAL( lStretch ) .AND. lStretch
      ::Stretch := .T.
   ENDIF
   ::Picture := uImage
   ::Checked := lChecked
   ::Hilited := lHilited
   IF HB_ISLOGICAL( lDisabled ) .AND. lDisabled
      ::Enabled := .F.
   ENDIF
   ASSIGN ::nTimeout VALUE nTimeout TYPE "N"
   ASSIGN ::cStatMsg VALUE cMsg     TYPE "CM"
   IF HB_ISLOGICAL( lDefault ) .AND. lDefault
      ::DefaultItemById()
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertItem( cCaption, bAction, cName, uImage, lChecked, lDisabled, uParent, lHilited, ;
                   lRight, lStretch, nBreak, nPos, cMsg, lDefault, cFontId, nTimeout ) CLASS TMenuItem

   LOCAL nStyle, nId, hFont := NIL

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::OwnerDraw          := uParent:OwnerDraw
      ::lIsAtBar           := ( uParent:Type == "MENU" .AND. uParent:lMain )
      DEFAULT cMsg     TO uParent:cStatMsg
      DEFAULT cFontID  TO uParent:cFontID
      DEFAULT nTimeout TO uParent:nTimeout
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()

   nStyle := MF_BYPOSITION
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   IF HB_ISNUMERIC( nBreak )
      IF nBreak == 1
         nStyle += MF_MENUBREAK
         ::lIsMenuBreak := .T.
      ELSE
         nStyle += MF_MENUBARBREAK
      ENDIF
   ENDIF
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // Append to the end
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      IF ValidHandler( cFontId )
         ::hExternFont := cFontId
         ::cFontId := cFontId
      ELSEIF HB_ISSTRING( cFontId )
         IF ! Empty( cFontId ) .AND. ValidHandler( hFont := GetFontHandle( cFontId ) )
            ::hExternFont := hFont
            ::cFontId := cFontId
         ENDIF
      ELSEIF HB_ISARRAY( cFontId )
         ASize( cFontId, 11 )
         ::hExternFont := ::SetFont( cFontId[ 1 ], cFontId[ 2 ], cFontId[ 3 ], cFontId[ 4 ], cFontId[ 5 ], cFontId[ 6 ], ;
                                     cFontId[ 7 ], cFontId[ 8 ], cFontId[ 9 ], cFontId[ 10 ], cFontId[ 11 ] )
         ::cFontId := cFontId
      ENDIF
      ::cCaption := cCaption
      ::xData := CreateMenuItemData( nId )
      InsertMenu( ::Container:hWnd, nId, ::xData, nStyle, nPos )
   ELSE
      nStyle += MF_STRING
      InsertMenu( ::Container:hWnd, nId, cCaption, nStyle, nPos )
   ENDIF
   ::Register( 0, cName, NIL, NIL, NIL, nId )

   ASSIGN ::OnClick VALUE bAction TYPE "B"
   IF HB_ISLOGICAL( lStretch ) .AND. lStretch
      ::Stretch := .T.
   ENDIF
   ::Picture := uImage
   ::Checked := lChecked
   ::Hilited := lHilited
   IF HB_ISLOGICAL( lDisabled )  .AND. lDisabled
      ::Enabled := .F.
   ENDIF
   ASSIGN ::nTimeout VALUE nTimeout TYPE "N"
   ASSIGN ::cStatMsg VALUE cMsg     TYPE "CM"
   IF HB_ISLOGICAL( lDefault ) .AND. lDefault
      ::DefaultItemById()
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineSeparator( cName, uParent, lRight ) CLASS TMenuItem

   LOCAL nStyle, nId

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::OwnerDraw          := uParent:OwnerDraw
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()

   nStyle := MF_SEPARATOR
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      ::xData := CreateMenuItemData( nId )
      AppendMenu( ::Container:hWnd, nId, ::xData, nStyle )
   ELSE
      AppendMenu( ::Container:hWnd, nId, NIL, nStyle ) 
   ENDIF
   ::Register( 0, cName, NIL, NIL, NIL, nId )
   ::lIsSeparator := .T.

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertSeparator( cName, uParent, lRight, nPos ) CLASS TMenuItem

   LOCAL nStyle, nId

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::lOwnerDraw := uParent:OwnerDraw
   ENDIF
   ::SetForm( cName, uParent )
   nId := _GetId()

   nStyle := MF_BYPOSITION + MF_SEPARATOR
   IF HB_ISLOGICAL( lRight ) .AND. lRight
      nStyle += MF_RIGHTJUSTIFY
   ENDIF
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // default is at the end
   IF ::lOwnerDraw
      nStyle += MF_OWNERDRAW
      ::xData := CreateMenuItemData( nId )
      InsertMenu( ::Container:hWnd, nId, ::xData, nStyle, nPos )
   ELSE
      InsertMenu( ::Container:hWnd, nId, NIL, nStyle, nPos )      
   ENDIF
   ::Register( 0, cName, NIL, NIL, NIL, nId )
   ::lIsSeparator := .T.

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OwnerDraw( lValue ) CLASS TMenuItem

   IF HB_ISLOGICAL( lValue )
      ::lOwnerDraw := lValue
   ENDIF

   RETURN ::lOwnerDraw

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TMenuItem

   IF HB_ISLOGICAL( lEnabled )
      ::lEnabled := lEnabled
      MenuEnabled( ::Container:hWnd, ::Position(), ::ContainerEnabled )
      ::Container:Refresh()
   ENDIF

   RETURN ::lEnabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Checked( lChecked ) CLASS TMenuItem

   LOCAL lRet

   IF ::lIsAtBar
      lRet := .F.
   ELSE
      lRet := MenuChecked( ::Container:hWnd, ::Position(), lChecked )
      ::Container:Refresh()
   ENDIF

   RETURN lRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Hilited( lHilited ) CLASS TMenuItem

   LOCAL lRet

   lRet := MenuHilited( ::Container:hWnd, ::Position(), lHilited, ::Parent:hWnd )
   ::Container:Refresh()
//   ::Parent:Redraw()

   RETURN lRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( cCaption ) CLASS TMenuItem

   IF ::lOwnerDraw
      IF HB_ISSTRING( cCaption ) .AND. cCaption # ::cCaption
         ::cCaption := cCaption
         ::Container:Refresh()
      ENDIF
   ELSE
      ::cCaption := MenuCaption( ::Container:hWnd, ::Id )
      IF HB_ISSTRING( cCaption ) .AND. cCaption # ::cCaption
         ::cCaption := MenuCaption( ::Container:hWnd, ::Id, cCaption )
         ::Container:Refresh()
      ENDIF
   ENDIF

   RETURN ::cCaption

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( uImages ) CLASS TMenuItem

   LOCAL nAttributes

   IF HB_ISARRAY( uImages )
      IF Len( uImages ) > 1
         // Change checked bitmap
         IF ValType( uImages[2] ) # "CM"
            ::aPicture[2] := uImages[2]
         ELSE
            ::aPicture[2] := ""
         ENDIF
      ENDIF

      IF Len( uImages ) > 0
         // Change unchecked bitmap
         IF ValType( uImages[1] ) # "CM"
            ::aPicture[1] := uImages[1]
         ELSE
            ::aPicture[1] := ""
         ENDIF
      ENDIF
   ELSEIF ValType( uImages ) $ "CM"
      // Change unchecked bitmap only
      ::aPicture[1] := uImages
   ELSE
      RETURN ::aPicture
   ENDIF

   // Release old images
   IF ::hBitMaps[1] != NIL
     DeleteObject( ::hBitMaps[1] )
     ::hBitMaps[1] := NIL
   ENDIF
   IF ::hBitMaps[2] != NIL
     DeleteObject( ::hBitMaps[2] )
     ::hBitMaps[2] := NIL
   ENDIF

   nAttributes := iif( ::lOwnerDraw, 0, iif( OSisWinVISTAorLater(), 1, 2) )

   IF ::lIsPopUp
      ::hBitMaps := MenuItem_SetBitMaps( ::Container:hWnd, ::Position(), ::aPicture[1], ::aPicture[2], ::lStretch, nAttributes, .T. )
   ELSE
      ::hBitMaps := MenuItem_SetBitMaps( ::Container:hWnd, ::Id, ::aPicture[1], ::aPicture[2], ::lStretch, nAttributes, .F. )
   ENDIF

   RETURN ::aPicture

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Stretch( lStretch ) CLASS TMenuItem

   /*
   When .F. (default behavior)
      XP clips big images to expected size (defined by system metrics' parameters
      SM_CXMENUCHECK and SM_CYMENUCHECK, usually 13x13 pixels).
      Vista and Win7 show big images at their real size.
   When .T.
     XP, Vista and Win7 scale down big images to expected size.
   */
   IF HB_ISLOGICAL( lStretch )
      IF lStretch != ::lStretch
         ::lStretch := lStretch
         ::Picture( ::aPicture )
      ENDIF
   ENDIF

   RETURN ::lStretch

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Border3D( lValue ) CLASS TMenuItem

   RETURN::oMenuParams:Border3D( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Colors( aNewColors ) CLASS TMenuItem

   RETURN ::oMenuParams:Colors( aNewColors )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CursorType( nSize ) CLASS TMenuItem

   RETURN ::oMenuParams:CursorType( nSize )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Gradient( lValue ) CLASS TMenuItem

   RETURN ::oMenuParams:Gradient( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SeparatorType( nType ) CLASS TMenuItem

   RETURN ::oMenuParams:SeparatorType( nType )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TMenuItem

   ::oMenuParams := NIL

   IF ::hBitMaps[1] != NIL
     DeleteObject( ::hBitMaps[1] )
     ::hBitMaps[1] := NIL
   ENDIF
   IF ::hBitMaps[2] != NIL
     DeleteObject( ::hBitMaps[2] )
     ::hBitMaps[2] := NIL
   ENDIF

   DeleteMenu( ::Container:hWnd, ::Id )
   IF ::xData != NIL
      DeleteMenuItemData( ::xData )
      ::xData := NIL
   ENDIF
   ::Container:Refresh()

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPopUp() CLASS TMenuItem

   _OOHG_AppObject():ActiveMenuRemove( Self )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetItemsColor( uColor, lApplyToSubItems ) CLASS TMenuItem

   IF ::lIsPopUp
      TMenuItemSetItemsColor( Self, uColor, lApplyToSubItems )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TMenuItem

   LOCAL aNew, uCargo

   IF ::Cargo == NIL .AND. ::Container:Cargo == NIL .AND. ::Parent:Cargo == NIL
      aNew := aParams
   ELSE
      IF aParams == NIL
         aNew := {}
      ELSEIF HB_ISARRAY( aParams )
         aNew := AClone( aParams )
      ELSE
         aNew := { aParams }
      ENDIF

      IF ! ::Cargo == NIL
         uCargo := ::Cargo
      ELSEIF ! ::Container:Cargo == NIL
         uCargo := ::Container:Cargo
      ELSE
         uCargo := ::Parent:Cargo
      ENDIF
      ASize( aNew, Len( aNew ) + 1 )
      AIns( aNew, 1 )
      aNew[ 1 ] := uCargo
   ENDIF

   RETURN ::Super:DoEvent( bBlock, cEventType, aNew )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_InitMenuPopUp( nPos ) CLASS TMenuItem

   _OOHG_EVAL( ::bOnInitPopUp, Self, nPos )

  RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_MenuHilited() CLASS TMenuItem

   LOCAL oStatusBar, cMsg

   IF _IsControlDefined( "StatusBar", ::Parent:Name )
      oStatusBar := GetControlObject( "StatusBar", ::Parent:Name )
      IF ValType( ::cStatMsg ) $ "CM"
         oStatusBar:Item( 1, ::cStatMsg )
         oStatusBar:InitTimeout( ::nTimeout )
      ELSE
         IF ValType( cMsg := oStatusBar:cStatMsg ) $ "CM"
            oStatusBar:Item( 1, cMsg )
            oStatusBar:InitTimeout( ::nTimeout )
         ELSEIF ValType( cMsg := _OOHG_DefaultStatusBarMsg ) $ "CM"
            oStatusBar:Item( 1, cMsg )
            oStatusBar:InitTimeout( ::nTimeout )
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Position() CLASS TMenuItem

   LOCAL uRet

   IF ::lIsPopUp
      uRet := FindPopUpPosition( ::Container:hWnd, ::hWnd )
   ELSE
      uRet := FindItemPosition( ::Container:hWnd, ::Id )
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_MeasureItem( lParam ) CLASS TMenuItem

   LOCAL hFont, nWidth, nHeight, nYDelta, nXDelta, nBmpSize

   IF ValidHandler( ::hExternFont )
      hFont := ::hExternFont
   ELSE
#define DEFAULT_GUI_FONT    17
      hFont := GetStockObject( DEFAULT_GUI_FONT )
   ENDIF

   IF ::lIsSeparator
      nHeight := ::oMenuParams:aMenuParams[ MNUBMP_YDELTA ] * 2
      nWidth := 0
   ELSE
      ::GetDC()
      nWidth := GetTextWidth( ::hDC, ::Caption, hFont )
      nHeight := GetTextHeight( ::hDC, ::Caption, hFont )
      ::ReleaseDC()
      nYDelta := ::oMenuParams:aMenuParams[ MNUBMP_YDELTA ]
      nBmpSize :=::oMenuParams:aMenuParams[ MNUBMP_SIZE ]
      nHeight = nYDelta + Max( nHeight, nBmpSize + nYDelta )
      IF ! ::lIsMenuBreak .AND. ! ::lIsAtBar
         // leave space for the checkmark
         nXDelta := ::oMenuParams:aMenuParams[ MNUBMP_XDELTA ]
         nWidth += nXDelta + nBmpSize + nXDelta + 8                  // TODO: Check 8
      ENDIF
   ENDIF

   TMenuItemMeasure( lParam, nWidth, nHeight )

   RETURN 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_DrawItem( lParam ) CLASS TMenuItem

   RETURN TMenuItemDraw( lParam, ::Caption, ::hExternFont, ::oMenuParams:aMenuParams, ::lIsSeparator, ! ::lIsAtBar, ::hBitmaps )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndMenuPopup()

   LOCAL oActiveMenu := _OOHG_AppObject():ActiveMenuGet()

   IF oActiveMenu # NIL
      oActiveMenu:EndPopUp()
   ENDIF

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMenuItemMRU FROM TControl

   DATA aItems                         INIT {}            // { { oCtrl, cName }, ... }
   DATA cFontId                        INIT NIL
   DATA cIniFile                       INIT "mru.ini"
   DATA cIniSection                    INIT "MRU"
   DATA cMsgItems                      INIT NIL
   DATA lIsAtBar                       INIT .F.
   DATA lOwnerDraw                     INIT .F.
   DATA nMaxItems                      INIT 7
   DATA nMaxLen                        INIT 40
   DATA nTimeout                       INIT NIL
   DATA oMenuParams                    INIT NIL
   DATA oTopItem                       INIT NIL
   DATA Type                           INIT "MENUMRUITEM" READONLY
   DATA uAction                        INIT NIL

   METHOD AddItem
   METHOD Border3D                     SETGET
   METHOD Clear
   METHOD Colors                       SETGET
   METHOD CursorType                   SETGET
   METHOD Define
   METHOD Gradient                     SETGET
   METHOD IniFile                      SETGET
   METHOD MaxItems                     SETGET
   METHOD Release
   METHOD Save
   METHOD SeparatorType                SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uParent, cName, cCaption, uAction, nItems, cFile, cSection, uImage, ;
               lStretch, lHilited, cMsgTop, cMsgItems, nBreak, lDefault, cFontId, nTimeout ) CLASS TMenuItemMRU

   LOCAL i, cValue := "", aCaptions := {}, bAction

   ::oMenuParams := TMenuParams()
   IF Empty( uParent )
      uParent := _OOHG_AppObject():ActiveMenuGet()
   ENDIF
   IF ! Empty( uParent )
      ::oMenuParams:Colors := uParent:Colors
      ::lOwnerDraw         := uParent:OwnerDraw
      ::lIsAtBar           := ( uParent:Type == "MENU" .AND. uParent:lMain )
      DEFAULT cMsgTop   TO uParent:cStatMsg
      DEFAULT cMsgItems TO uParent:cStatMsg
      DEFAULT cFontID   TO uParent:cFontID
      DEFAULT nTimeout  TO uParent:nTimeout
   ENDIF
   ::SetForm( cName, uParent )
   ::Register( 0, cName, NIL, NIL, NIL, _GetId() )

   IF ! ValType( cCaption ) $ "CM" .OR. Empty( cCaption )
      cCaption := _OOHG_Messages( MT_MISCELL, 13 )
   ENDIF
   IF ValType( uAction ) $ "CM"
      IF ( i := At( "(", uAction ) ) > 0
         uAction := Left( uAction, i - 1 )
      ENDIF
      IF Empty( uAction )
         bAction := { || NIL }
         uAction := NIL
      ELSE
         bAction := &( "{ || " + uAction + "() }" )
         ::uAction := uAction
      ENDIF
   ELSEIF HB_ISBLOCK( uAction )
      ::uAction := uAction
      bAction := uAction
   ELSE
      bAction := { || NIL }
      uAction := NIL
   ENDIF
   IF HB_ISNUMERIC( nItems ) .AND. nItems > 0
      ::nMaxItems := nItems
   ENDIF
   IF ValType( cFile ) $ "CM" .AND. ! Empty( cFile )
      ::cIniFile := cFile
   ENDIF
   IF ValType( cSection ) $ "CM" .AND. ! Empty( cSection )
      ::cIniSection := cSection
   ENDIF
   IF ValType( cMsgItems ) $ "CM" .AND. ! Empty( cMsgItems )
      ::cMsgItems := cMsgItems
   ENDIF
   IF ValType( cFontId ) $ "CM" .AND. ! Empty( cFontId )
      ::cFontId := cFontId
   ENDIF
   ASSIGN ::nTimeout VALUE nTimeout TYPE "N"

   BEGIN INI FILE ::cIniFile
      FOR i := 1 TO ::nMaxItems
         GET cValue SECTION ::cIniSection ENTRY hb_ntos( i ) DEFAULT ""
         IF Empty( cValue )
            EXIT
         ENDIF
         AAdd( aCaptions, cValue )
      NEXT i
   END INI

   ::oTopItem := TMenuItem():DefineItem( cCaption, bAction, cName, uImage, .F., .F., uParent, lHilited, ;
                                         .F., lStretch, nBreak, cMsgTop, lDefault, cFontId, ::nTimeout )
   SEPARATOR
   FOR i := Len( aCaptions ) TO 1 STEP -1
      ::AddItem( aCaptions[ i ], uAction )
   NEXT

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddItem( cCaption, uAction ) CLASS TMenuItemMRU

   LOCAL i, bAction, oItem, cNew, nLen, nPos

   IF ValType( cCaption ) $ "CM" .AND. ! Empty( cCaption )
      // check if the item is already in the list
      i := AScan( ::aItems, { |a| Upper( a[ 2 ] ) == Upper( cCaption ) } )
      IF i > 0
         // found, remove old item
         ::aItems[ i, 1 ]:Release()
         ADel( ::aItems, i )
         ASize( ::aItems, Len( ::aItems ) - 1 )
      ENDIF

      // see what to do when clicked
      IF PCount() > 1
         IF ValType( uAction ) $ "CM"
            IF ( i := At( "(", uAction ) ) > 0
               uAction := Left( uAction, i - 1 )
            ENDIF
            IF Empty( uAction )
               uAction := NIL
            ENDIF
         ENDIF
      ELSE
         uAction := ::uAction
      ENDIF
      IF ValType( uAction ) $ "CM"
         bAction := &( "{ || " + ::uAction + "( '" + cCaption + "' ) }" )
      ELSEIF HB_ISBLOCK( uAction )
         bAction := uAction
      ELSE
         bAction := { || NIL }
      ENDIF

      nPos := ::oTopItem:Position() + 2

      // add new item to position 1
      oItem := TMenuItem():InsertItem( "&1 " + cCaption, bAction, NIL, NIL, NIL, NIL, ::oTopItem:Container, ;
                                       NIL, NIL, NIL, NIL, nPos, ::cMsgItems, .F., ::cFontId, ::nTimeout )

      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, 1 )
      ::aItems[ 1 ] := { oItem, cCaption }
      oItem:Cargo := cCaption

      // remove last item if needed
      IF Len( ::aItems ) > ::nMaxItems
         ::aItems[ Len( ::aItems ), 1 ]:Release()
         ASize( ::aItems, ::nMaxItems )
      ENDIF

      // update item's captions
      FOR i := 2 to Len( ::aItems )
         cNew := ::aItems[ i, 2 ]
         nLen := Len( cNew )
         IF nLen + 4 > ::nMaxLen
            cNew := "&" + hb_ntos( i ) + " " + SubStr( cNew, 1, 6 ) + "..." + Right( cNew, 27 )
         ELSE
            cNew := "&" + hb_ntos( i ) + " " + cNew
         ENDIF
         ::aItems[ i, 1 ]:Caption := cNew
      NEXT i
   ENDIF

RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Border3D( lValue ) CLASS TMenuItemMRU

   RETURN ::oMenuParams:Border3D( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Clear() CLASS TMenuItemMRU

   LOCAL i

   FOR i := 1 to Len( ::aItems )
      ::aItems[ i, 1 ]:Release()
   NEXT i
   ::aItems := {}

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Colors( aNewColors ) CLASS TMenuItemMRU

   RETURN ::oMenuParams:Colors( aNewColors )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CursorType( nSize ) CLASS TMenuItemMRU

   RETURN ::oMenuParams:CursorType( nSize )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Gradient( lValue ) CLASS TMenuItemMRU

   RETURN ::oMenuParams:Gradient( lValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IniFile( aData ) CLASS TMenuItemMRU

   IF HB_ISARRAY( aData ) .AND. Len( aData ) > 0
      IF ValType( aData[ 1 ] ) $ "CM"
         ::cIniFile := aData[ 1 ]
      ENDIF
      IF Len( aData ) > 1 .AND. ValType( aData[ 2 ] ) $ "CM"
         ::cIniSection := aData[ 2 ]
      ENDIF
   ENDIF

   RETURN { ::cIniFile, ::cIniSection }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxItems( nCant ) CLASS TMenuItemMRU

   IF HB_ISNUMERIC( nCant ) .AND. nCant > 1
      DO WHILE Len( ::aItems ) > nCant
         ATail( ::aItems ):Release()
         ASize( ::aItems, Len( ::aItems ) - 1 )
      ENDDO
      ::nMaxItems := nCant
   ENDIF

   RETURN ::nMaxItems

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TMenuItemMRU

   ::Save()
   ::Clear()
   ::oTopItem:Release()
   ::oTopItem := NIL
   ::oMenuParams := NIL

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Save() CLASS TMenuItemMRU

   LOCAL i := 1, m

   BEGIN INI FILE ::cIniFile
      m := Min( Len( ::aItems ), ::nMaxItems )
      DO WHILE i <= m
         SET SECTION ::cIniSection ENTRY hb_ntos( i ) TO ::aItems[ i, 2 ]
         i ++
      ENDDO
      DO WHILE i <= ::nMaxItems
         SET SECTION ::cIniSection ENTRY hb_ntos( i ) TO ""
         i ++
      ENDDO
   END INI

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SeparatorType( nType ) CLASS TMenuItemMRU

   RETURN ::oMenuParams:SeparatorType( nType )


/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"

#ifndef _INCLUDE_OOHG_MENU_CONSTANTS_
#define _INCLUDE_OOHG_MENU_CONSTANTS_ "OOHG menu related constants"
#endif
#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CREATEMENUITEMDATA )          /* FUNCTION CreateMenuItemData( nId ) -> hStruct */
{
   LPMYITEM lpItem = ( MYITEM * ) hb_xgrab( ( sizeof( MYITEM ) ) );

   lpItem->id = hb_parnl( 1 );         // used by WM_DRAWITEM and WM_MEASUREITEM handlers in h_windows.prg

   HB_RETNL( ( LONG_PTR ) lpItem );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DELETEMENUITEMDATA )          /* FUNCTION DeleteMenuItemData( hStruct ) -> NIL */
{
   LPMYITEM lpItem = ( MYITEM * ) HB_PARNL( 1 );

   hb_xfree( lpItem );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TRACKPOPUPMENU )          /* FUNCTION TrackPopUpMenu( hMenu, nCol, nRow, hWnd ) -> NIL */
{
   HWND hwnd = HWNDparam( 4 );

   SetForegroundWindow( hwnd );
   TrackPopupMenu( HMENUparam( 1 ), 0, hb_parni( 2 ), hb_parni( 3 ), 0, hwnd, 0 );
   PostMessage( hwnd, WM_NULL, 0, 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETMENUITEMCOUNT )          /* FUNCTION GetItemCount( hMenu ) -> nCount */
{
   hb_retni( GetMenuItemCount( HMENUparam( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static INT FindItemPos( HMENU hMenu, UINT iItem )
{
   // based on the original work of Jochen Ruhland
   // https://www.codeguru.com/cpp/controls/menu/miscellaneous/article.php/c191/Finding-a-menuitem-from-command-id.htm

   HMENU hSubMenu;
   INT nPos, nFound;

   for( nPos = GetMenuItemCount( hMenu ) -1; nPos >= 0; nPos-- )
   {
      if( ( INT ) GetMenuState( hMenu, nPos, MF_BYPOSITION ) == -1 )
      {
         // invalid Menu/Position combination, return 'not found'
         return -1;
      }

      if( GetMenuItemID( hMenu, nPos ) == iItem )
      {
         // found!
         return nPos;
      }

      hSubMenu = GetSubMenu( hMenu, nPos );
      if( hSubMenu != NULL )
      {
         nFound = FindItemPos( hSubMenu, iItem );
         if( nFound >= 0 )
         {
            return nFound;
         }
      }
   }

   return -1;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( FINDITEMPOSITION )          /* FUNCTION FindItemPosition( hMenu, ItemID ) -> nPos */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT iItem = ( UINT ) hb_parni( 2 );

  hb_retni( FindItemPos( hMenu, iItem ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static INT FindPopUpPos( HMENU hMenu, HMENU hPopUp )
{
   HMENU hSubMenu;
   INT nPos, nFound;

   for( nPos = GetMenuItemCount( hMenu ) -1; nPos >= 0; nPos -- )
   {
      if( ( INT ) GetMenuState( hMenu, nPos, MF_BYPOSITION ) == -1 )
      {
         // invalid Menu/Position combination, return 'not found'
         return -1;
      }

      hSubMenu = GetSubMenu( hMenu, nPos );
      if( hSubMenu != NULL )
      {
         if( hSubMenu == hPopUp )
            return nPos;

         nFound = FindPopUpPos( hSubMenu, hPopUp );
         if( nFound >= 0 )
         {
            return nFound;
         }
      }
   }

   return -1;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( FINDPOPUPPOSITION )          /* FUNCTION FindPopUpPosition( hWndMenu, hWndPopUp ) -> nPos */
{
   HMENU hMenu = HMENUparam( 1 );
   HMENU hPopUp = HMENUparam( 2 );

  hb_retni( FindPopUpPos( hMenu, hPopUp ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INSERTMENU )          /* FUNCTION InsertMenu( hMenu, hMenu/nId, uData/cCaption, nStyle, nPos ) -> NIL */
{
   UINT style = ( UINT ) hb_parni( 4 );

   if( ( style & MF_OWNERDRAW ) == MF_OWNERDRAW )
   {
      hb_retl( InsertMenu( HMENUparam( 1 ), ( UINT ) hb_parni( 5 ), ( UINT ) hb_parni( 4 ), ( UINT_PTR ) HB_PARNL( 2 ), ( LPCSTR ) HB_PARNL( 3 ) ) );
   }
   else
   {
      hb_retl( InsertMenu( HMENUparam( 1 ), ( UINT ) hb_parni( 5 ), ( UINT ) hb_parni( 4 ), ( UINT_PTR ) HB_PARNL( 2 ), ( LPCSTR ) hb_parc( 3 ) ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( APPENDMENU )          /* FUNCTION AppendMenu( hMenu, hMenu/nId, uData/cCaption, nStyle ) -> NIL */
{
   UINT style = ( UINT ) hb_parni( 4 );

   if( ( style & MF_OWNERDRAW ) == MF_OWNERDRAW )
   {
      hb_retl( AppendMenu( HMENUparam( 1 ), style, ( UINT_PTR ) HB_PARNL( 2 ), ( LPCSTR ) HB_PARNL( 3 ) ) );
   }
   else
   {
      hb_retl( AppendMenu( HMENUparam( 1 ), style, ( UINT_PTR ) HB_PARNL( 2 ), ( LPCSTR ) hb_parc( 3 ) ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CREATEMENU )          /* FUNCTION CreateMenu() -> hMenu */
{
   HMENUret( CreateMenu() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CREATEPOPUPMENU )          /* FUNCTION CreatePopUpMenu() -> hMenu */
{
   HMENUret( CreatePopupMenu() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETMENU )          /* FUNCTION SetMenu( hWnd, hMenu ) -> lSuccess */
{
   hb_retl( SetMenu( HWNDparam( 1 ), HMENUparam( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( MENUCHECKED )          /* FUNCTION MenuChecked( hMenu, nPos, lChecked/NIL ) -> lChecked */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT nPos = ( UINT ) hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      CheckMenuItem( hMenu, nPos, MF_BYPOSITION | ( hb_parl( 3 ) ? MF_CHECKED : MF_UNCHECKED ) );
   }

   hb_retl( ( GetMenuState( hMenu, nPos, MF_BYPOSITION ) & MF_CHECKED ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( MENUENABLED )          /* FUNCTION MenuEnabled( hMenu, nPos, lEnabled/NIL ) -> lEnabled */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT nPos = ( UINT ) hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      EnableMenuItem( hMenu, nPos, MF_BYPOSITION | ( hb_parl( 3 ) ? MF_ENABLED : MF_GRAYED ) );
   }

   hb_retl( ! ( GetMenuState( hMenu, nPos, MF_BYPOSITION ) & MF_GRAYED ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( MENUHILITED )          /* FUNCTION MenuHilited( hMenu, nPos, lHilited/NIL, hWnd ) -> lHilited */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT nPos = ( UINT ) hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      HiliteMenuItem( HWNDparam( 4 ), hMenu, nPos, MF_BYPOSITION | ( hb_parl( 3 ) ? MF_HILITE : MF_UNHILITE ) );
   }

   hb_retl( ( GetMenuState( hMenu, nPos, MF_BYPOSITION ) & MF_HILITE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( MENUCAPTION )          /* FUNCTION MenuCaption( hWnd, nId, cCaption/NIL ) -> cCaption */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT iItem = ( UINT ) hb_parni( 2 );
   INT iLen;
   CHAR * cBuffer;
   MENUITEMINFO MenuItem;

   if( HB_ISCHAR( 3 ) )
   {
      memset( &MenuItem, 0, sizeof( MenuItem ) );
      MenuItem.cbSize = sizeof( MenuItem );
      MenuItem.fMask = MIIM_STRING;
      MenuItem.dwTypeData = ( LPSTR ) HB_UNCONST( hb_parc( 3 ) );
      MenuItem.cch = hb_parclen( 3 );
      SetMenuItemInfo( hMenu, iItem, MF_BYCOMMAND, &MenuItem );
   }

   iLen = GetMenuString( hMenu, iItem, NULL, 0, MF_BYCOMMAND );
   cBuffer = ( CHAR * ) hb_xgrab( iLen + 2 );
   iLen = GetMenuString( hMenu, iItem, ( LPSTR ) cBuffer, iLen + 1, MF_BYCOMMAND );
   hb_retclen( cBuffer, iLen );
   hb_xfree( cBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( MENUITEM_SETBITMAPS )          /* FUNCTION MenuItem_SetBitmaps( hWnd, nId/nPos, cImg1, cImg2, lStretch, iAttrFlag, lPopUp ) -> { hBitmap1, hBitmap2 } */
{
   HMENU hMenu = HMENUparam( 1 );
   UINT iItem = ( UINT ) hb_parni( 2 );
   HBITMAP himage1, himage2;
   INT iAttributes;
   INT nWidth = 0;
   INT nHeight = 0;
   BOOL bIgnoreBkClr;

   if( HB_ISLOG( 5 ) )
   {
      if( hb_parl( 5 ) )
      {
         nWidth = GetSystemMetrics( SM_CXMENUCHECK );
         nHeight = GetSystemMetrics( SM_CYMENUCHECK );
      }
   }

   if( hb_parni( 6 ) == 0 )
   {
      // ownerdraw
      bIgnoreBkClr = TRUE;
      iAttributes = LR_DEFAULTCOLOR;
   }
   else
   {
      bIgnoreBkClr = FALSE;
      if( hb_parni( 6 ) == 1 )
      {
         // is Vista or later
         iAttributes = LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT;
      }
      else
      {
         iAttributes = LR_LOADMAP3DCOLORS;
      }
   }

   himage1 = ( HBITMAP ) _OOHG_LoadImage( HB_UNCONST( hb_parc( 3 ) ), iAttributes, nWidth, nHeight, NULL, GetSysColor( COLOR_MENU ), bIgnoreBkClr );
   himage2 = ( HBITMAP ) _OOHG_LoadImage( HB_UNCONST( hb_parc( 4 ) ), iAttributes, nWidth, nHeight, NULL, GetSysColor( COLOR_MENU ), bIgnoreBkClr );

   if( hb_parl( 7 ) )
      SetMenuItemBitmaps( hMenu, iItem, MF_BYPOSITION, himage1, himage2 );
   else
      SetMenuItemBitmaps( hMenu, iItem, MF_BYCOMMAND, himage1, himage2 );

   hb_reta( 2 );
   HB_STORNL3( ( LONG_PTR ) himage1, -1, 1 );
   HB_STORNL3( ( LONG_PTR ) himage2, -1, 2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETMENUDEFAULTITEM )          /* FUNCTION SetMenuDefaultItem( hWnd, nPos ) -> lSuccess */
{
   hb_retl( SetMenuDefaultItem( HMENUparam( 1 ), hb_parni( 2 ) - 1, MF_BYPOSITION ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETMENUDEFAULTITEMBYID )          /* FUNCTION SetMenuDefaultItemByID( hWnd, nId ) -> lSuccess */
{
   hb_retl( SetMenuDefaultItem( HMENUparam( 1 ), hb_parni( 2 ), MF_BYCOMMAND ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETMENUBARHEIGHT )          /* FUNCTION GetMenuBarHeight() -> nHeight */
{
   hb_retni( GetSystemMetrics( SM_CYMENU ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DESTROYMENU )          /* FUNCTION DestroyMenu( hWnd ) -> lSuccess */
{
   hb_retl( DestroyMenu( HMENUparam( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DRAWMENUBAR )          /* FUNCTION DrawMenuBar( hWnd ) -> lSuccess */
{
   hb_retl( DrawMenuBar( HWNDparam( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DELETEMENU )          /* FUNCTION DeleteMenu( hWnd, nID ) -> lSuccess */
{
   hb_retl( DeleteMenu( HMENUparam( 1 ), hb_parni( 2 ), MF_BYCOMMAND ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TMENU_SETMENUBARCOLOR )          /* METHOD SetMenuBarColor( uColor, lApplyToSubMenus ) CLASS TMenu -> nColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   COLORREF Color;
   MENUINFO iMenuInfo;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : ( COLORREF ) oSelf->lBackColor;

         iMenuInfo.cbSize = sizeof( MENUINFO );
         GetMenuInfo( ( HMENU ) oSelf->hWnd, &iMenuInfo );

         iMenuInfo.hbrBack = CreateSolidBrush( Color );
         iMenuInfo.fMask   = MIM_BACKGROUND;
         if( hb_parl( 2 ) )
         {
            iMenuInfo.fMask |= MIM_APPLYTOSUBMENUS;
         }

         if( SetMenuInfo( ( HMENU ) oSelf->hWnd, &iMenuInfo ) )
         {
            DrawMenuBar( HWNDparam( 3 ) );
         }
      }
   }

   // return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TMENUITEMSETITEMSCOLOR )          /* FUNCTION TMenuItemSetItemsColor( oMenu, uColor, lApplyToSubItems ) -> nColor */
{
   PHB_ITEM pSelf = ( PHB_ITEM ) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   COLORREF Color;
   MENUINFO iMenuInfo;

   if( _OOHG_DetermineColorReturn( hb_param( 2, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 2 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : ( COLORREF ) oSelf->lBackColor;

         GetMenuInfo( ( HMENU ) oSelf->hWnd, &iMenuInfo );

         iMenuInfo.cbSize  = sizeof( MENUINFO );
         iMenuInfo.hbrBack = CreateSolidBrush( Color );
         iMenuInfo.fMask   = MIM_BACKGROUND;
         if( hb_parl( 3 ) )
         {
            iMenuInfo.fMask |= MIM_APPLYTOSUBMENUS;
         }

         if( SetMenuInfo( ( HMENU ) oSelf->hWnd, &iMenuInfo ) )
         {
            DrawMenuBar( oSelf->hWnd );
         }
      }
   }

   // return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TMENUITEMMEASURE )          /* FUNCTION TMenuItemMeasure( lParam, nWidth, nHeight ) -> NIL */
{
   LPMEASUREITEMSTRUCT lpmis = ( LPMEASUREITEMSTRUCT ) ( LPARAM ) HB_PARNL( 1 );
   lpmis->itemWidth = hb_parnl( 2 );
   lpmis->itemHeight = hb_parnl( 3 );
}

/*
HB_FUNC( TMENUITEMMEASURE )          // FUNCTION TMenuItemMeasure( lParam, lIsSeparator, lCheckMark, nWidth, nHeight ) -> NIL //
{
   LPMEASUREITEMSTRUCT lpmis = ( LPMEASUREITEMSTRUCT ) ( LPARAM ) HB_PARNL( 1 );
   INT cy, cx;

   if( hb_parl( 2 ) )
   {
      lpmis->itemHeight = 2 * iYDelta;
      lpmis->itemWidth  = 0;
   }
   else
   {
      cx = hb_parnl( 4 );
      cy = hb_parnl( 5 );

      lpmis->itemHeight = iYDelta + ( cy > iBmpSize + iYDelta ? cy : iBmpSize + iYDelta );

      if( hb_parl( 3 ) )
      {
         lpmis->itemWidth = iXDelta + iBmpSize + iXDelta + cx + 8;
      }
      else
      {
         lpmis->itemWidth = cx;
      }
   }
}
*/

/*--------------------------------------------------------------------------------------------------------------------------------*/
HBITMAP BitmapFromIcon( HICON hIcon, UINT diFlags )
{
   HDC      hDC    = GetDC( NULL );
   HDC      hMemDC = CreateCompatibleDC( hDC );
   ICONINFO icon;
   BITMAP   bitmap;
   HBITMAP  hBmp;
   HBITMAP  hOldBmp;

   GetIconInfo( ( HICON ) hIcon, &icon );
   GetObject( icon.hbmColor, sizeof( BITMAP ), ( LPVOID ) &bitmap );
   hBmp    = CreateCompatibleBitmap( hDC, bitmap.bmWidth, bitmap.bmHeight );
   hOldBmp = ( HBITMAP ) SelectObject( hMemDC, hBmp );
   PatBlt( hMemDC, 0, 0, bitmap.bmWidth, bitmap.bmHeight, WHITENESS );
   DrawIconEx( hMemDC, 0, 0, hIcon, bitmap.bmWidth, bitmap.bmHeight, 0, NULL, diFlags );
   SelectObject( hMemDC, hOldBmp );
   DeleteDC( hMemDC );
   DeleteObject( icon.hbmMask );
   DeleteObject( icon.hbmColor );
   ReleaseDC( NULL, hDC );
   return hBmp;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID FillGradient( HDC hDC, RECT * rect, BOOL vertical, COLORREF clrFrom, COLORREF clrTo )
{
   GRADIENT_RECT gRect;
   TRIVERTEX     Vert[ 2 ];
   ULONG         Mode = ( vertical ? GRADIENT_FILL_RECT_V : GRADIENT_FILL_RECT_H );

   Vert[ 0 ].y     = rect->top;
   Vert[ 0 ].x     = rect->left;
   Vert[ 0 ].Red   = ( COLOR16 ) ( GetRValue( clrFrom ) << 8 );
   Vert[ 0 ].Green = ( COLOR16 ) ( GetGValue( clrFrom ) << 8 );
   Vert[ 0 ].Blue  = ( COLOR16 ) ( GetBValue( clrFrom ) << 8 );
   Vert[ 0 ].Alpha = 0;

   Vert[ 1 ].y     = rect->bottom;
   Vert[ 1 ].x     = rect->right;
   Vert[ 1 ].Red   = ( COLOR16 ) ( GetRValue( clrTo ) << 8 );
   Vert[ 1 ].Green = ( COLOR16 ) ( GetGValue( clrTo ) << 8 );
   Vert[ 1 ].Blue  = ( COLOR16 ) ( GetBValue( clrTo ) << 8 );
   Vert[ 1 ].Alpha = 0;

   gRect.UpperLeft  = 0;
   gRect.LowerRight = 1;

   GradientFill( hDC, Vert, 2, &gRect, 1, Mode );
}

#define IsColorEqual( clr1, clr2 ) ( ( GetRValue( clr1 ) == GetRValue( clr2 ) ) && ( GetGValue( clr1 ) == GetGValue( clr2 ) ) && ( GetBValue( clr1 ) == GetBValue( clr2 ) ) )

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID DrawMenuTextBkgrnd( HDC hDC, RECT rect, BOOL bSelected, BOOL bGrayed, BOOL bCheckMark,
                                COLORREF clrSelectedMenuBarItem1, COLORREF clrSelectedMenuBarItem2,
                                COLORREF clrSelectedBk1, COLORREF clrSelectedBk2,
                                COLORREF clrMenuBar1, COLORREF clrMenuBar2,
                                COLORREF clrBk1, COLORREF clrBk2,
                                COLORREF clrGrayedBk1, COLORREF clrGrayedBk2 )
{
   HBRUSH brush;

   if( bGrayed )
   {
      if( IsColorEqual( clrGrayedBk1, clrGrayedBk2 ) )
      {
         brush = CreateSolidBrush( clrGrayedBk1 );
         FillRect( hDC, &rect, brush );
         DeleteObject( brush );
      }
      else
      {
         FillGradient( hDC, &rect, FALSE, clrGrayedBk1, clrGrayedBk2 );
      }
   }
   else
   {
      if( bSelected )
      {
         if( bCheckMark )
         {
            if( IsColorEqual( clrSelectedBk1, clrSelectedBk2 ) )
            {
               brush = CreateSolidBrush( clrSelectedBk1 );
               FillRect( hDC, &rect, brush );
               DeleteObject( brush );
            }
            else
            {
               FillGradient( hDC, &rect, TRUE, clrSelectedBk1, clrSelectedBk2 );
            }
         }
         else
         {
            if( IsColorEqual( clrSelectedMenuBarItem1, clrSelectedMenuBarItem2 ) )
            {
               brush = CreateSolidBrush( clrSelectedMenuBarItem1 );
               FillRect( hDC, &rect, brush );
               DeleteObject( brush );
            }
            else
            {
               FillGradient( hDC, &rect, TRUE, clrSelectedMenuBarItem1, clrSelectedMenuBarItem2 );
            }
         }
      }
      else
      {
         if( bCheckMark )
         {
            if( IsColorEqual( clrBk1, clrBk2 ) )
            {
               brush = CreateSolidBrush( clrBk1 );
               FillRect( hDC, &rect, brush );
               DeleteObject( brush );
            }
            else
            {
               FillGradient( hDC, &rect, FALSE, clrBk1, clrBk2 );
            }
         }
         else
         {
            if( IsColorEqual( clrMenuBar1, clrMenuBar2 ) )
            {
               brush = CreateSolidBrush( clrMenuBar1 );
               FillRect( hDC, &rect, brush );
               DeleteObject( brush );
            }
            else
            {
               FillGradient( hDC, &rect, TRUE, clrMenuBar1, clrMenuBar2 );
            }
         }
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID DrawMenuSelectedItemBorder( HDC hDC, RECT rect, BOOL bCheckMark, BOOL bBorderIs3D,
                                        COLORREF clrSelectedItemBorder1, COLORREF clrSelectedItemBorder2,
                                        COLORREF clrSelectedItemBorder3, COLORREF clrSelectedItemBorder4 )
{
   HPEN pen, pen1, oldPen;

   if( bCheckMark )
   {
      pen  = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder1 );
      pen1 = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder3 );
   }
   else
   {
      pen  = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder2 );
      pen1 = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder4 );
   }

   oldPen = ( HPEN ) SelectObject( hDC, pen );

   MoveToEx( hDC, rect.left, rect.top, NULL );

   if( ! bCheckMark && bBorderIs3D )
   {
      LineTo( hDC, rect.right, rect.top );
      SelectObject( hDC, pen1 );
      LineTo( hDC, rect.right, rect.bottom );
      LineTo( hDC, rect.left, rect.bottom );
      SelectObject( hDC, pen );
      LineTo( hDC, rect.left, rect.top );
   }
   else
   {
      LineTo( hDC, rect.right, rect.top );
      LineTo( hDC, rect.right, rect.bottom );
      LineTo( hDC, rect.left, rect.bottom );
      LineTo( hDC, rect.left, rect.top );
   }

   SelectObject( hDC, oldPen );
   DeleteObject( pen );
   DeleteObject( pen1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID DrawMenuImage( HDC hDC, int x, int y, int dx, int dy, HBITMAP hBmp, LONG lColor, BOOL disabled, BOOL stretched )
{
   HDC      hDCMem, hDCMask, hDCStretch, hDCNoBlink;
   HBITMAP  hBmpDefault, hBmpTransMask, hBmpStretch = NULL, hBmpIcon = NULL, hBmpNoBlink, hBmpNoBlinkOld;
   BITMAP   bitmap;
   ICONINFO icon;
   HBRUSH   newBrush, oldBrush;
   COLORREF clrTransparent = ( COLORREF ) lColor;
   BOOL     bHasBkColor = ( lColor != -1 );

   if( ( UINT ) GetObject( hBmp, sizeof( BITMAP ), ( LPVOID ) &bitmap ) != sizeof( BITMAP ) )
   {
      if( ! GetIconInfo( ( HICON ) hBmp, &icon ) )
      {
         return;
      }

      DeleteObject( icon.hbmMask );
      DeleteObject( icon.hbmColor );

      if( ! icon.fIcon )
      {
         return;
      }

      if( ! disabled && ! stretched )
      {
         DrawIconEx( hDC, x, y, ( HICON ) hBmp, dx, dy, 0, NULL, DI_NORMAL );
         return;
      }

      if( ! stretched )
      {
         hBmp = BitmapFromIcon( ( HICON ) hBmp, DI_MASK );
      }
      else
      {
         hBmp = BitmapFromIcon( ( HICON ) hBmp, DI_NORMAL );
      }

      hBmpIcon = hBmp;

      clrTransparent = RGB( 255, 255, 255 );
      bHasBkColor = TRUE;
      GetObject( hBmp, sizeof( BITMAP ), ( LPVOID ) &bitmap );
   }

   hDCMem = CreateCompatibleDC( hDC );

   if( stretched )
   {
      dx = ( dx > 0 ? dx : bitmap.bmWidth );
      dy = ( dy > 0 ? dy : bitmap.bmHeight );
      hBmpStretch = CreateCompatibleBitmap( hDC, dx, dy );
      SelectObject( hDCMem, hBmpStretch );
      hDCStretch  = CreateCompatibleDC( hDC );
      hBmpDefault = ( HBITMAP ) SelectObject( hDCStretch, hBmp );
      StretchBlt( hDCMem, 0, 0, dx, dy, hDCStretch, 0, 0, bitmap.bmWidth, bitmap.bmHeight, SRCCOPY );
      SelectObject( hDCStretch, hBmpDefault );
      DeleteDC( hDCStretch );
   }
   else
   {
      dx = ( dx > 0 ? HB_MIN( dx, bitmap.bmWidth ) : bitmap.bmWidth );
      dy = ( dy > 0 ? HB_MIN( dy, bitmap.bmHeight ) : bitmap.bmHeight );
      hBmpDefault = ( HBITMAP ) SelectObject( hDCMem, hBmp );
   }

   hDCNoBlink     = CreateCompatibleDC( hDC );
   hBmpNoBlink    = CreateCompatibleBitmap( hDC, dx, dy );
   hBmpNoBlinkOld = ( HBITMAP ) SelectObject( hDCNoBlink, hBmpNoBlink );
   BitBlt( hDCNoBlink, 0, 0, dx, dy, hDC, x, y, SRCCOPY );
   SetBkColor( hDCNoBlink, RGB( 255, 255, 255 ) );
   SetTextColor( hDCNoBlink, RGB( 0, 0, 0 ) );

   if( ! bHasBkColor )
   {
      clrTransparent = GetPixel( hDCMem, 0, 0 );
   }

   hDCMask = CreateCompatibleDC( hDCNoBlink );
   hBmpTransMask = CreateBitmap( dx, dy, 1, 1, NULL );
   SelectObject( hDCMask, hBmpTransMask );
   SetBkColor( hDCMem, clrTransparent );
   BitBlt( hDCMask, 0, 0, dx, dy, hDCMem, 0, 0, SRCCOPY );

   if( disabled )
   {
      newBrush = GetSysColorBrush( COLOR_BTNHIGHLIGHT );
      oldBrush = ( HBRUSH ) SelectObject( hDCNoBlink, newBrush );
      BitBlt( hDCNoBlink, 1, 1, dx, dy, hDCMask, 0, 0, 12060490 );
      SelectObject( hDCNoBlink, oldBrush );
      DeleteObject( newBrush );
      newBrush = GetSysColorBrush( COLOR_BTNSHADOW );
      oldBrush = ( HBRUSH ) SelectObject( hDCNoBlink, newBrush );
      BitBlt( hDCNoBlink, 0, 0, dx, dy, hDCMask, 0, 0, 12060490 );
      SelectObject( hDCNoBlink, oldBrush );
      DeleteObject( newBrush );
   }
   else
   {
      BitBlt( hDCNoBlink, 0, 0, dx, dy, hDCMem, 0, 0, SRCINVERT );
      BitBlt( hDCNoBlink, 0, 0, dx, dy, hDCMask, 0, 0, SRCAND );
      BitBlt( hDCNoBlink, 0, 0, dx, dy, hDCMem, 0, 0, SRCINVERT );
   }
   BitBlt( hDC, x, y, dx, dy, hDCNoBlink, 0, 0, SRCCOPY );

   SelectObject( hDCMem, hBmpDefault );
   SelectObject( hDCMask, hBmpDefault );
   SelectObject( hDCNoBlink, hBmpNoBlinkOld );
   DeleteDC( hDCMem );
   DeleteDC( hDCMask );
   DeleteDC( hDCNoBlink );
   DeleteObject( hBmpTransMask );
   DeleteObject( hBmpNoBlink );
   if( stretched )
   {
      DeleteObject( hBmpStretch );
   }
   if( hBmpIcon )
   {
      DeleteObject( hBmpIcon );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID DrawMenuCheckMark( HDC hdc, SIZE size, RECT rect, INT iBmpSize, INT iXDelta, INT iYDelta, BOOL bDisabled,
                               BOOL bSelected, BOOL bShortCursor, COLORREF clrSelectedBk1, COLORREF clrCheckMarkBk,
                               COLORREF clrCheckMarkSq, COLORREF clrCheckMarkGr, COLORREF clrCheckMark )
{
   HPEN hNewPen, hOldPen;
   HBRUSH hNewBrush, hOldBrush;
   UINT x, y, w, h;

   if( bSelected && bShortCursor )
   {
      hNewBrush = CreateSolidBrush( clrSelectedBk1 );
   }
   else
   {
      hNewBrush = CreateSolidBrush( clrCheckMarkBk );
   }

   hOldBrush = ( HBRUSH ) SelectObject( hdc, hNewBrush );

   hNewPen = CreatePen( PS_SOLID, ( UINT ) 1, clrCheckMarkSq );
   hOldPen = ( HPEN ) SelectObject( hdc, hNewPen );

   w = ( size.cx > iBmpSize + iXDelta ? iBmpSize + iXDelta : size.cx );
   h = w;
   x = rect.left + ( iBmpSize + iXDelta - w ) / 2;
   y = rect.top + ( iYDelta + iBmpSize + iYDelta - h ) / 2;

   Rectangle( hdc, x, y, x + w, y + h );

   DeleteObject( hNewPen );

   if( bDisabled )
   {
      hNewPen = CreatePen( PS_SOLID, ( UINT ) 1, clrCheckMarkGr );
   }
   else
   {
      hNewPen = CreatePen( PS_SOLID, ( UINT ) 1, clrCheckMark );
   }

   SelectObject( hdc, hNewPen );

   MoveToEx( hdc, x + 1, y + 5, NULL );
   LineTo( hdc, x + 4, y + h - 2 );
   MoveToEx( hdc, x + 2, y + 5, NULL );
   LineTo( hdc, x + 4, y + h - 3 );
   MoveToEx( hdc, x + 2, y + 4, NULL );
   LineTo( hdc, x + 5, y + h - 3 );
   MoveToEx( hdc, x + 4, y + h - 3, NULL );
   LineTo( hdc, x + w + 2, y - 1 );
   MoveToEx( hdc, x + 4, y + h - 2, NULL );
   LineTo( hdc, x + w - 2, y + 3 );

   SelectObject( hdc, hOldPen );
   SelectObject( hdc, hOldBrush );
   DeleteObject( hNewPen );
   DeleteObject( hNewBrush );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID DrawMenuSeparator( HDC hDC, RECT r, INT iXDelta, INT iBmpSize, BOOL bDoubleSeparator, UINT uSeparatorPosition,
                               COLORREF clrImageBk1, COLORREF clrImageBk2, COLORREF clrBk1, COLORREF clrBk2,
                               COLORREF clrSeparator1, COLORREF clrSeparator2 )
{
   HPEN pen, oldPen;
   RECT rect;
   HBRUSH brush;
   HPEN pen1, oldPen1;

   CopyRect( &rect, &r );
   rect.right = rect.left + iXDelta + iBmpSize + iXDelta / 2;

   if( IsColorEqual( clrImageBk1, clrImageBk2 ) )
   {
      brush = CreateSolidBrush( clrImageBk1 );
      FillRect( hDC, &rect, brush );
      DeleteObject( brush );
   }
   else
   {
      FillGradient( hDC, &rect, FALSE, clrImageBk1, clrImageBk2 );
   }

   CopyRect( &rect, &r );
   rect.left += ( iXDelta + iBmpSize + iXDelta / 2 );

   if( IsColorEqual( clrBk1, clrBk2 ) )
   {
      brush = CreateSolidBrush( clrBk1 );
      FillRect( hDC, &rect, brush );
      DeleteObject( brush );
   }
   else
   {
      FillGradient( hDC, &rect, FALSE, clrBk1, clrBk2 );
   }

   CopyRect( &rect, &r );
   if( uSeparatorPosition == MNUSEP_RIGHT )
   {
      rect.left += ( iXDelta + iBmpSize + iXDelta + 2 );
   }
   else if( uSeparatorPosition == MNUSEP_MIDDLE )
   {
      rect.left  += iBmpSize;
      rect.right -= iBmpSize;
   }
   rect.top += ( rect.bottom - rect.top ) / 2;

   pen = CreatePen( PS_SOLID, ( UINT ) 1, clrSeparator1 );
   oldPen = ( HPEN ) SelectObject( hDC, pen );

   MoveToEx( hDC, rect.left, rect.top, NULL );
   LineTo( hDC, rect.right, rect.top );

   if( bDoubleSeparator )
   {
      pen1 = CreatePen( PS_SOLID, ( UINT ) 1, clrSeparator2 );
      oldPen1 = ( HPEN ) SelectObject( hDC, pen1 );

      rect.top += 1;
      MoveToEx( hDC, rect.left, rect.top, NULL );
      LineTo( hDC, rect.right, rect.top );

      SelectObject( hDC, oldPen1 );
      DeleteObject( pen1 );
   }

   SelectObject( hDC, oldPen );
   DeleteObject( pen );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TMENUITEMDRAW )          /* FUNCTION TMenuItemDraw( lParam, cCaption, hFont, aMenuParams, lIsSeparator, lCheckMark, aBitmaps ) -> .T. */
{
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) ( LPARAM ) HB_PARNL( 1 );
   HFONT hFont = ( HFONT ) HB_PARNL( 3 );
   BOOL bSeparator = hb_parl( 5 );
   BOOL bCheckMark = hb_parl( 6 );
   HBITMAP hBmpUnchecked = ( HBITMAP ) HB_PARNL2( 7, 1 );
   HBITMAP hBmpChecked = ( HBITMAP ) HB_PARNL2( 7, 2 );
   COLORREF clrText, clrBackground;
   UINT bkMode;
   HPEN pen, pen1, oldPen;
   RECT rect;
   SIZE size;
   BOOL bSelected, bGrayed, bChecked;
   HFONT hOldFont = 0;
   HBRUSH brush;
   // colors
   COLORREF clrMenuBar1             = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARBACKGROUND1 );
   COLORREF clrMenuBar2             = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARBACKGROUND2 );
   COLORREF clrMenuBarText          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARTEXT );
   COLORREF clrMenuBarSelectedText  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARSELECTEDTEXT );
   COLORREF clrMenuBarGrayedText    = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARGRAYEDTEXT );
   COLORREF clrSelectedMenuBarItem1 = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARSELECTEDITEM1 );
   COLORREF clrSelectedMenuBarItem2 = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUBARSELECTEDITEM2 );
   COLORREF clrText1                = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMTEXT );
   COLORREF clrSelectedText1        = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMSELECTEDTEXT );
   COLORREF clrGrayedText1          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMGRAYEDTEXT );
   COLORREF clrBk1                  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMBACKGROUND1 );
   COLORREF clrBk2                  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMBACKGROUND2 );
   COLORREF clrSelectedBk1          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMSELECTEDBACKGROUND1 );
   COLORREF clrSelectedBk2          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMSELECTEDBACKGROUND2 );
   COLORREF clrGrayedBk1            = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMGRAYEDBACKGROUND1 );
   COLORREF clrGrayedBk2            = ( COLORREF ) HB_PARNL2( 4, MNUCLR_MENUITEMGRAYEDBACKGROUND2 );
   COLORREF clrImageBk1             = ( COLORREF ) HB_PARNL2( 4, MNUCLR_IMAGEBACKGROUND1 );
   COLORREF clrImageBk2             = ( COLORREF ) HB_PARNL2( 4, MNUCLR_IMAGEBACKGROUND2 );
   COLORREF clrSeparator1           = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SEPARATOR1 );
   COLORREF clrSeparator2           = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SEPARATOR2 );
   COLORREF clrSelectedItemBorder1  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SELECTEDITEMBORDER1 );
   COLORREF clrSelectedItemBorder2  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SELECTEDITEMBORDER2 );
   COLORREF clrSelectedItemBorder3  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SELECTEDITEMBORDER3 );
   COLORREF clrSelectedItemBorder4  = ( COLORREF ) HB_PARNL2( 4, MNUCLR_SELECTEDITEMBORDER4 );
   COLORREF clrCheckMark            = ( COLORREF ) HB_PARNL2( 4, MNUCLR_CHECKMARK );
   COLORREF clrCheckMarkBk          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_CHECKMARKBACKGROUND );
   COLORREF clrCheckMarkSq          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_CHECKMARKSQUARE );
   COLORREF clrCheckMarkGr          = ( COLORREF ) HB_PARNL2( 4, MNUCLR_CHECKMARKGRAYED );
   // other parameters
   BOOL bShortCursor                = ( BOOL )     HB_PARNL2( 4, MNUCUR_SIZE );
   BOOL bDoubleSeparator            = ( BOOL )     HB_PARNL2( 4, MNUSEP_TYPE );
   UINT uSeparatorPosition          = ( UINT )     HB_PARNL2( 4, MNUSEP_POSITION );
   BOOL bGradient                   = ( BOOL )     HB_PARNL2( 4, MNUGRADIENT );
   BOOL bBorderIs3D                 = ( BOOL )     HB_PARNL2( 4, MNUBOR_IS3D );
   BOOL iBmpSize                    = ( INT )      HB_PARNL2( 4, MNUBMP_SIZE );
   BOOL iXDelta                     = ( INT )      HB_PARNL2( 4, MNUBMP_XDELTA );
   BOOL iYDelta                     = ( INT )      HB_PARNL2( 4, MNUBMP_YDELTA );

/*
 * ODA_DRAWENTIRE - This bit is set when the entire control needs to be drawn.
 * ODA_FOCUS - This bit is set when the control gains or loses input focus. The itemState member should be checked to determine whether the control has focus.
 * ODA_SELECT - This bit is set when only the selection status has changed. The itemState member should be checked to determine the new selection state.
 *
 * Owner draw state:
 * ODS_CHECKED - This bit is set IF the menu item is to be checked. This bit is used only in a menu.
 * ODS_DISABLED - This bit is set IF the item is to be drawn as disabled.
 * ODS_FOCUS - This bit is set IF the item has input focus.
 * ODS_GRAYED - This bit is set IF the item is to be dimmed. This bit is used only in a menu.
 * ODS_SELECTED - This bit is set IF the item's status is selected.
 * ODS_COMBOBOXEDIT - The drawing takes place in the selection field (edit control) of an ownerdrawn combo box.
 * ODS_DEFAULT - The item is the default item.
 */

   // draw separator
   if( bSeparator )
   {
      if( bGradient )
      {
         DrawMenuSeparator( lpdis->hDC, lpdis->rcItem, iXDelta, iBmpSize, bDoubleSeparator, uSeparatorPosition,
                            clrImageBk1, clrImageBk2, clrBk1, clrBk2, clrSeparator1, clrSeparator2 );
      }
      else
      {
         DrawMenuSeparator( lpdis->hDC, lpdis->rcItem, iXDelta, iBmpSize, bDoubleSeparator, uSeparatorPosition,
                            clrImageBk1, clrImageBk1, clrBk1, clrBk1, clrSeparator1, clrSeparator2 );
      }
      hb_retl( TRUE );
      return;
   }

   // set font
   if( hFont )
   {
      hOldFont = ( HFONT ) SelectObject( lpdis->hDC, hFont );
   }

   // save previous colours state
   clrText = SetTextColor( lpdis->hDC, clrText1 );
   clrBackground = SetBkColor( lpdis->hDC, clrBk1 );
   bkMode = SetBkMode( lpdis->hDC, TRANSPARENT );

   // set colors and flags
   if( ( ( lpdis->itemAction & ODA_SELECT ) || ( lpdis->itemAction & ODA_DRAWENTIRE ) ) && ! ( lpdis->itemState & ODS_GRAYED ) )
   {
      if( lpdis->itemState & ODS_SELECTED )
      {
         clrText = SetTextColor( lpdis->hDC, bCheckMark ? clrSelectedText1 : clrMenuBarSelectedText );
         clrBackground = SetBkColor( lpdis->hDC, bCheckMark ? clrSelectedBk1 : clrMenuBar1 );
         bSelected = TRUE;
      }
      else
      {
         clrText = SetTextColor( lpdis->hDC, bCheckMark ? clrText1 : clrMenuBarText );
         clrBackground = SetBkColor( lpdis->hDC, bCheckMark ? clrBk2 : clrMenuBar2 );
         bSelected = FALSE;
      }
   }
   else
   {
      bSelected = FALSE;
   }

   if( lpdis->itemState & ODS_GRAYED )
   {
      clrText = SetTextColor( lpdis->hDC, bCheckMark ? clrGrayedText1 : clrMenuBarGrayedText );
      bGrayed = TRUE;
   }
   else
   {
      bGrayed = FALSE;
   }

   if( lpdis->itemState & ODS_CHECKED )
   {
      bChecked = TRUE;
   }
   else
   {
      bChecked = FALSE;
   }

   // draw menu item bitmap background
   if( bCheckMark )
   {
      CopyRect( &rect, &lpdis->rcItem );
      rect.right = rect.left + iXDelta + iBmpSize + iXDelta / 2;
      if( bGradient & ! IsColorEqual( clrImageBk1, clrImageBk2 ) )
      {
         FillGradient( lpdis->hDC, &rect, FALSE, clrImageBk1, clrImageBk2 );
      }
      else
      {
         brush = CreateSolidBrush( clrImageBk1 );
         FillRect( lpdis->hDC, &rect, brush );
         DeleteObject( brush );
      }
   }
   
   //draw menu item background
   CopyRect( &rect, &lpdis->rcItem );
   if( bCheckMark )
   {
      if( bSelected )
      {
         if( bShortCursor && ( bChecked || hBmpUnchecked != NULL ) )
         {
            rect.left += ( iXDelta + iBmpSize + iXDelta / 2 );
         }
      }
      else
      {
         rect.left += ( iXDelta + iBmpSize + iXDelta / 2 );
      }
   }
   if( bGradient )
   {
      DrawMenuTextBkgrnd( lpdis->hDC, rect, bSelected, bGrayed, bCheckMark,
                          clrSelectedMenuBarItem1, clrSelectedMenuBarItem2, clrSelectedBk1, clrSelectedBk2,
                          clrMenuBar1, clrMenuBar2, clrBk1, clrBk2, clrGrayedBk1, clrGrayedBk2 );
   }
   else
   {
      DrawMenuTextBkgrnd( lpdis->hDC, rect, bSelected, bGrayed, bCheckMark,
                          clrSelectedMenuBarItem1, clrSelectedMenuBarItem1, clrSelectedBk1, clrSelectedBk1,
                          clrMenuBar1, clrMenuBar1, clrBk1, clrBk1, clrGrayedBk1, clrGrayedBk1 );
   }

   // draw menu item border
   if( bSelected && ! bGrayed )
   {
      CopyRect( &rect, &lpdis->rcItem );
      if( bShortCursor && bCheckMark && ( bChecked || hBmpUnchecked != NULL ) )
      {
         rect.left += ( iXDelta + iBmpSize + iXDelta / 2 );
      }
      InflateRect( &rect, -1, -1 );
      DrawMenuSelectedItemBorder( lpdis->hDC, rect, bCheckMark, bBorderIs3D, clrSelectedItemBorder1,
                                  clrSelectedItemBorder2, clrSelectedItemBorder3, clrSelectedItemBorder4 );
   }

   // draw bitmap
   if( ( hBmpUnchecked != NULL ) && ! bChecked )
   {
      CopyRect( &rect, &lpdis->rcItem );
      rect.left += iXDelta - 2;
      rect.top += iYDelta;
      DrawMenuImage( lpdis->hDC, rect.left, rect.top, iBmpSize, iBmpSize, hBmpUnchecked, -1, bGrayed, TRUE );

      if( bSelected && ! bCheckMark && bShortCursor && bBorderIs3D )
      {
         pen  = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder2 );
         pen1 = CreatePen( PS_SOLID, ( UINT ) 1, clrSelectedItemBorder4 );
         oldPen = ( HPEN ) SelectObject( lpdis->hDC, pen1 );

         CopyRect( &rect, &lpdis->rcItem );
         rect.left += ( iXDelta / 2 - 2 );
         rect.top += ( iYDelta / 2 );
         rect.right = rect.left + iBmpSize + iXDelta;
         rect.bottom = rect.top + iBmpSize + iYDelta;

         MoveToEx( lpdis->hDC, rect.left, rect.top, NULL );
         LineTo( lpdis->hDC, rect.right, rect.top );
         SelectObject( lpdis->hDC, pen );
         LineTo( lpdis->hDC, rect.right, rect.bottom );
         LineTo( lpdis->hDC, rect.left, rect.bottom );
         SelectObject( lpdis->hDC, pen1 );
         LineTo( lpdis->hDC, rect.left, rect.top );

         SelectObject( lpdis->hDC, oldPen );
         DeleteObject( pen );
         DeleteObject( pen1 );
      }
   }

   // draw menu item text
   if( bCheckMark )
   {
      CopyRect( &rect, &lpdis->rcItem );
      rect.left += ( iXDelta + iBmpSize + iXDelta + 2 );
      DrawText( lpdis->hDC, hb_parc( 2 ), -1, &rect, DT_LEFT | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS | DT_EXPANDTABS );
   }
   else
   {
      DrawText( lpdis->hDC, hb_parc( 2 ), -1, &lpdis->rcItem, DT_CENTER | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS | DT_EXPANDTABS );
   }

   // draw menu item checked mark
   if( bChecked )
   {
      if( hBmpChecked )
      {
         CopyRect( &rect, &lpdis->rcItem );
         rect.left += iXDelta / 2;
         rect.top += iYDelta / 2 + 2;
         DrawMenuImage( lpdis->hDC, rect.left, rect.top, iBmpSize, iBmpSize, hBmpChecked, -1, bGrayed, TRUE );
      }
      else
      {
         size.cx = iBmpSize;
         size.cy = iBmpSize;
         DrawMenuCheckMark( lpdis->hDC, size, lpdis->rcItem, iBmpSize, iXDelta, iYDelta, bGrayed, bSelected, bShortCursor,
                            clrSelectedBk1, clrCheckMarkBk, clrCheckMarkSq, clrCheckMarkGr, clrCheckMark );
      }
   }

   // restore state
   if( hFont )
   {
      SelectObject( lpdis->hDC, hOldFont );
   }
   SetTextColor( lpdis->hDC, clrText );
   SetBkColor( lpdis->hDC, clrBackground );
   SetBkMode( lpdis->hDC, bkMode );

   hb_retl( TRUE );
}

#pragma ENDDUMP


/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DefaultMenuParams( nSet )

   LOCAL aMenuParams := Array( MNUPAR_COUNT ), lIsXP

   ASSIGN nSet VALUE nSet TYPE "N" DEFAULT 0

   SWITCH nSet
   CASE 0
      aMenuParams[ MNUCLR_MENUBARBACKGROUND1 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARBACKGROUND2 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARTEXT ]                 := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUBARSELECTEDTEXT ]         := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUBARGRAYEDTEXT ]           := ArrayRGB_TO_COLORREF( SILVER )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM1 ]        := RGB( 255, 252, 248 )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM2 ]        := RGB( 136, 133, 116 )
      aMenuParams[ MNUCLR_MENUITEMTEXT ]                := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDTEXT ]        := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDTEXT ]          := ArrayRGB_TO_COLORREF( SILVER )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND1 ]         := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND2 ]         := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB( 182, 189, 210 )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB( 182, 189, 210 )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND1 ]   := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND2 ]   := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND1 ]            := RGB( 246, 245, 244 )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND2 ]            := RGB( 207, 210, 200 )
      aMenuParams[ MNUCLR_SEPARATOR1 ]                  := RGB( 168, 169, 163 )
      aMenuParams[ MNUCLR_SEPARATOR2 ]                  := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER1 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER2 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER3 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER4 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_CHECKMARK ]                   := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_CHECKMARKBACKGROUND ]         := RGB( 216, 220, 224 )
      aMenuParams[ MNUCLR_CHECKMARKSQUARE ]             := RGB( 64, 116, 200 )
      aMenuParams[ MNUCLR_CHECKMARKGRAYED ]             := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCUR_SIZE ]                        := MNUCUR_FULL
      aMenuParams[ MNUSEP_TYPE ]                        := MNUSEP_SINGLE
      aMenuParams[ MNUSEP_POSITION ]                    := MNUSEP_RIGHT
      aMenuParams[ MNUGRADIENT ]                        := 1
      aMenuParams[ MNUBOR_IS3D ]                        := 1
      aMenuParams[ MNUBMP_SIZE ]                        := 16
      aMenuParams[ MNUBMP_XDELTA ]                      := 4
      aMenuParams[ MNUBMP_YDELTA ]                      := 4
      EXIT
   CASE 1
      lIsXP := "XP" $ WindowsVersion()[ 1 ]
      aMenuParams[ MNUCLR_MENUBARBACKGROUND1 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARBACKGROUND2 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARTEXT ]                 := GetSysColor( COLOR_MENUTEXT )
      aMenuParams[ MNUCLR_MENUBARSELECTEDTEXT ]         := GetSysColor( COLOR_HIGHLIGHTTEXT )
      aMenuParams[ MNUCLR_MENUBARGRAYEDTEXT ]           := GetSysColor( COLOR_GRAYTEXT )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM1 ]        := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM2 ]        := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_MENUITEMTEXT ]                := GetSysColor( COLOR_MENUTEXT )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDTEXT ]        := GetSysColor( COLOR_HIGHLIGHTTEXT )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDTEXT ]          := GetSysColor( COLOR_GRAYTEXT )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND1 ]         := IF( lIsXP, GetSysColor( COLOR_MENU ), ArrayRGB_TO_COLORREF( WHITE ) )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND2 ]         := IF( lIsXP, GetSysColor( COLOR_MENU ), ArrayRGB_TO_COLORREF( WHITE ) )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND1 ]   := IF( lIsXP, GetSysColor( COLOR_MENU ), ArrayRGB_TO_COLORREF( WHITE ) )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND2 ]   := IF( lIsXP, GetSysColor( COLOR_MENU ), ArrayRGB_TO_COLORREF( WHITE ) )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND1 ]            := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND2 ]            := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_SEPARATOR1 ]                  := GetSysColor( COLOR_GRAYTEXT )
      aMenuParams[ MNUCLR_SEPARATOR2 ]                  := GetSysColor( COLOR_HIGHLIGHTTEXT )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER1 ]         := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER2 ]         := GetSysColor( COLOR_HIGHLIGHT )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER3 ]         := GetSysColor( COLOR_GRAYTEXT )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER4 ]         := GetSysColor( COLOR_HIGHLIGHTTEXT )
      aMenuParams[ MNUCLR_CHECKMARK ]                   := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_CHECKMARKBACKGROUND ]         := RGB( 216, 220, 224 )
      aMenuParams[ MNUCLR_CHECKMARKSQUARE ]             := RGB( 64, 116, 200 )
      aMenuParams[ MNUCLR_CHECKMARKGRAYED ]             := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCUR_SIZE ]                        := MNUCUR_FULL
      aMenuParams[ MNUSEP_TYPE ]                        := MNUSEP_DOUBLE
      aMenuParams[ MNUSEP_POSITION ]                    := MNUSEP_RIGHT
      aMenuParams[ MNUGRADIENT ]                        := 1
      aMenuParams[ MNUBOR_IS3D ]                        := 0
      aMenuParams[ MNUBMP_SIZE ]                        := 16
      aMenuParams[ MNUBMP_XDELTA ]                      := 4
      aMenuParams[ MNUBMP_YDELTA ]                      := 4
      EXIT
   CASE 2
      aMenuParams[ MNUCLR_MENUBARBACKGROUND1 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARBACKGROUND2 ]          := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARTEXT ]                 := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUBARSELECTEDTEXT ]         := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUBARGRAYEDTEXT ]           := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM1 ]        := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUBARSELECTEDITEM2 ]        := GetSysColor( COLOR_BTNFACE )
      aMenuParams[ MNUCLR_MENUITEMTEXT ]                := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDTEXT ]        := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDTEXT ]          := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND1 ]         := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_MENUITEMBACKGROUND2 ]         := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND1 ]   := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_MENUITEMGRAYEDBACKGROUND2 ]   := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND1 ]            := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_IMAGEBACKGROUND2 ]            := RGB( 212, 208, 200 )
      aMenuParams[ MNUCLR_SEPARATOR1 ]                  := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCLR_SEPARATOR2 ]                  := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER1 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER2 ]         := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER3 ]         := RGB(  10,  36, 106 )
      aMenuParams[ MNUCLR_SELECTEDITEMBORDER4 ]         := ArrayRGB_TO_COLORREF( WHITE )
      aMenuParams[ MNUCLR_CHECKMARK ]                   := ArrayRGB_TO_COLORREF( BLACK )
      aMenuParams[ MNUCLR_CHECKMARKBACKGROUND ]         := RGB( 216, 220, 224 )
      aMenuParams[ MNUCLR_CHECKMARKSQUARE ]             := RGB( 64, 116, 200 )
      aMenuParams[ MNUCLR_CHECKMARKGRAYED ]             := ArrayRGB_TO_COLORREF( GRAY )
      aMenuParams[ MNUCUR_SIZE ]                        := MNUCUR_SHORT
      aMenuParams[ MNUSEP_TYPE ]                        := MNUSEP_DOUBLE
      aMenuParams[ MNUSEP_POSITION ]                    := MNUSEP_LEFT
      aMenuParams[ MNUGRADIENT ]                        := 1
      aMenuParams[ MNUBOR_IS3D ]                        := 1
      aMenuParams[ MNUBMP_SIZE ]                        := 16
      aMenuParams[ MNUBMP_XDELTA ]                      := 4
      aMenuParams[ MNUBMP_YDELTA ]                      := 4
      EXIT
   END SWITCH

   RETURN aMenuParams

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MenuCursorType( nSize )

   LOCAL aMenuParams := _OOHG_DefaultMenuParams

   IF HB_ISNUMERIC( nSize ) .AND. ( nSize == MNUCUR_FULL .OR. nSize == MNUCUR_SHORT )
      aMenuParams[ MNUCUR_SIZE ] := nSize
      _OOHG_DefaultMenuParams := aMenuParams
   ENDIF

   RETURN _OOHG_DefaultMenuParams[ MNUCUR_SIZE ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MenuSeparator( nType, nPosition )

   LOCAL aMenuParams := _OOHG_DefaultMenuParams

   IF HB_ISNUMERIC( nType ) .AND. ( nType == MNUSEP_SINGLE .OR. nType == MNUSEP_DOUBLE ) .AND. ;
      HB_ISNUMERIC( nPosition ) .AND. ( nPosition == MNUSEP_LEFT .OR. nPosition == MNUSEP_MIDDLE .OR. nPosition == MNUSEP_RIGHT )
      aMenuParams[ MNUSEP_TYPE ] := nType
      aMenuParams[ MNUSEP_POSITION ] := nPosition
      _OOHG_DefaultMenuParams := aMenuParams
   ENDIF

   RETURN { _OOHG_DefaultMenuParams[ MNUSEP_TYPE ], _OOHG_DefaultMenuParams[ MNUSEP_POSITION ] }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MenuBorderStyle( lValue )

   LOCAL aMenuParams := _OOHG_DefaultMenuParams

   IF HB_ISLOGICAL( lValue )
      aMenuParams[ MNUBOR_IS3D ] := iif( lValue, 1, 0 )
      _OOHG_DefaultMenuParams := aMenuParams
   ENDIF

   RETURN _OOHG_DefaultMenuParams[ MNUBOR_IS3D ] == 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MenuGradientStyle( lValue )

   LOCAL aMenuParams := _OOHG_DefaultMenuParams

   IF HB_ISLOGICAL( lValue )
      aMenuParams[ MNUGRADIENT ] := iif( lValue, 1, 0 )
      _OOHG_DefaultMenuParams := aMenuParams
   ENDIF

   RETURN _OOHG_DefaultMenuParams[ MNUGRADIENT ] == 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MenuBitmapMetrics( aMetrics )

   LOCAL lChange := .F., aMenuParams := _OOHG_DefaultMenuParams

   IF HB_ISARRAY( aMetrics )
      IF Len( aMetrics ) > 0 .AND. HB_ISNUMERIC( aMetrics[ 1 ] ) .AND. aMetrics[ 1 ] > 0
         lChange := .T.
         aMenuParams[ MNUBMP_SIZE ] := aMetrics[ 1 ]
      ENDIF
      IF Len( aMetrics ) > 1 .AND. HB_ISNUMERIC( aMetrics[ 2 ] ) .AND. aMetrics[ 2 ] >= 0
         lChange := .T.
         aMenuParams[ MNUBMP_XDELTA ] := aMetrics[ 2 ]
      ENDIF
      IF Len( aMetrics ) > 2 .AND. HB_ISNUMERIC( aMetrics[ 3 ] ) .AND. aMetrics[ 3 ] >= 0
         lChange := .T.
         aMenuParams[ MNUBMP_YDELTA ] := aMetrics[ 3 ]
      ENDIF
   ENDIF
   IF lChange
      aMenuParams := _OOHG_DefaultMenuParams := aMenuParams
   ENDIF

   RETURN { aMenuParams[ MNUBMP_SIZE ], aMenuParams[ MNUBMP_XDELTA ], aMenuParams[ MNUBMP_YDELTA ] }
