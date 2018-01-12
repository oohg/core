/*
 * $Id: h_menu.prg $
 */
/*
 * ooHG source code:
 * Menu controls
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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
 * Copyright 1999-2017, https://harbour.github.io/
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

STATIC _OOHG_xMenuActive := {}

CLASS TMenu FROM TControl

   DATA lAdjust                   INIT .F.
   DATA lMain                     INIT .F.
   DATA Type                      INIT "MENU" READONLY

   METHOD Activate
   METHOD Define
   METHOD DisableVisualStyle
   METHOD EndMenu
   METHOD Refresh
   METHOD Release                 BLOCK { |Self| DestroyMenu( ::hWnd ), ::Super:Release() }
   METHOD Separator               BLOCK { |Self| TMenuItem():DefineSeparator( , Self ) }
   METHOD SetMenuBarColor

   ENDCLASS

METHOD Define( Parent, Name ) CLASS TMenu

   ::SetForm( Name, Parent )
   ::Container := NIL
   ::Register( CreatePopUpMenu() )
   AADD( _OOHG_xMenuActive, Self )

   Return Self

METHOD DisableVisualStyle CLASS TMenu

   IF ::IsVisualStyled
      ::Parent:DisableVisualStyle()
      IF ! ::Parent:IsVisualStyled
         ::lVisualStyled := .F.
      ENDIF
   ENDIF

   RETURN Nil

METHOD Activate( nRow, nCol ) CLASS TMenu

   Local aPos

   aPos := GetCursorPos()
   ASSIGN aPos[ 1 ] VALUE nRow TYPE "N"
   ASSIGN aPos[ 2 ] VALUE nCol TYPE "N"
   TrackPopupMenu( ::hWnd, aPos[ 2 ], aPos[ 1 ], ::Parent:hWnd )

   Return nil

METHOD EndMenu() CLASS TMenu

   Local nPos

   nPos := ASCAN( _OOHG_xMenuActive, { |o| o:hWnd == ::hWnd } )
   IF nPos > 0
      ADEL( _OOHG_xMenuActive, nPos )
      ASIZE( _OOHG_xMenuActive, LEN( _OOHG_xMenuActive ) - 1 )
   ENDIF
   ::Refresh()

   Return Nil

METHOD Refresh() CLASS TMenu

   IF ::lMain
      DrawMenuBar( ::Parent:hWnd )
   ENDIF

   Return Nil


CLASS TMenuMain FROM TMenu

   DATA lMain     INIT .T.

   METHOD Define
   METHOD Activate    BLOCK { || nil }
   METHOD Release     BLOCK { |Self| ::Parent:oMenu := nil, ::Super:Release() }

   ENDCLASS

METHOD Define( Parent, Name ) CLASS TMenuMain

   ::SetForm( Name, Parent )
   ::Container := NIL
   ::Register( CreateMenu() )
   AADD( _OOHG_xMenuActive, Self )
   If ::Parent:oMenu != nil
      // Error: MAIN MENU already defined for this window
      ::Parent:oMenu:Release()
   EndIf
   SetMenu( ::Parent:hWnd, ::hWnd )
   ::Parent:oMenu := Self

   Return Self


CLASS TMenuContext FROM TMenu

   METHOD Define
   METHOD Release     BLOCK { |Self| ::Parent:ContextMenu := nil, ::Super:Release() }

   ENDCLASS

METHOD Define( Parent, Name ) CLASS TMenuContext

   ::Super:Define( Parent, Name )
   If ::Parent:ContextMenu != nil
      ::Parent:ContextMenu:Release()
   EndIf
   ::Parent:ContextMenu := Self

   Return Self


CLASS TMenuNotify FROM TMenu

   METHOD Define
   METHOD Release     BLOCK { |Self| ::Parent:NotifyMenu := nil, ::Super:Release() }

   ENDCLASS

METHOD Define( Parent, Name ) CLASS TMenuNotify

   ::Super:Define( Parent, Name )
   IF ::Parent:NotifyMenu != nil
      ::Parent:NotifyMenu:Release()
   ENDIF
   ::Parent:NotifyMenu := Self

   Return Self


CLASS TMenuDropDown FROM TMenu

   METHOD Define
   METHOD Release

   ENDCLASS

METHOD Define( Button, Parent, Name ) CLASS TMenuDropDown

   LOCAL oContainer

   If HB_IsObject( Button )
      Parent := Button:Parent
      Button := Button:Name
   EndIf
   ::Super:Define( Parent, Name )
   oContainer := GetControlObject( Button, ::Parent:Name )
   If oContainer:ContextMenu != nil
      oContainer:ContextMenu:Release()
   EndIf
   oContainer:ContextMenu := Self

   Return Self

METHOD Release() CLASS TMenuDropDown

   If ::Container != nil
      ::Container:ContextMenu := nil
   Endif

   Return ::Super:Release()

Function _EndMenu()

   IF LEN( _OOHG_xMenuActive ) > 0
      ATAIL( _OOHG_xMenuActive ):EndMenu()
   ENDIF

   Return Nil


CLASS TMenuItem FROM TControl

   DATA Type      INIT "MENUITEM" READONLY
   DATA xId       INIT 0
   DATA lMain     INIT .F.
   DATA aPicture  INIT {"", ""}
   DATA hBitMaps  INIT {nil, nil}
   DATA lStretch  INIT .F.
   DATA lIsPopUp  INIT .F.
   DATA lAdjust   INIT .F.

   METHOD DefinePopUp
   METHOD DefineItem
   METHOD DefineSeparator
   METHOD InsertPopUp
   METHOD InsertItem
   METHOD InsertSeparator
   METHOD SetItemsColor
   METHOD Enabled              SETGET
   METHOD Checked              SETGET
   METHOD Hilited              SETGET
   METHOD Caption              SETGET
   METHOD Release
   METHOD EndPopUp
   METHOD Separator            BLOCK { |Self| TMenuItem():DefineSeparator( , Self ) }
   METHOD Picture              SETGET
   METHOD Stretch              SETGET
   METHOD DoEvent
   METHOD DefaultItem( nItem ) BLOCK { |Self,nItem| SetMenuDefaultItem( ::Container:hWnd, nItem ) }

   ENDCLASS

METHOD DefinePopUp( Caption, Name, checked, disabled, Parent, hilited, Image, ;
                    lRight, lStretch, nBreak ) CLASS TMenuItem

   LOCAL nStyle

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   ::Register( CreatePopupMenu(), Name )
   ::xId := ::hWnd
   AADD( _OOHG_xMenuActive, Self )
   nStyle := MF_POPUP + MF_STRING + IF( ValType( lRight ) == "L" .AND. lRight, MF_RIGHTJUSTIFY, 0 ) + ;
             IF( ValType( nBreak ) != "N", 0, IF( nBreak == 1, MF_MENUBREAK, MF_MENUBARBREAK ) )
   AppendMenu( ::Container:hWnd, ::hWnd, Caption, nStyle )
   if HB_IsLogical( lStretch ) .AND. lStretch
      ::Stretch := .T.
   EndIf
   ::Picture := image
   ::Checked := checked
   ::Hilited := hilited
   if HB_IsLogical( disabled ) .AND. disabled
      ::Enabled := .F.
   EndIf
   ::lIsPopUp := .T.

   Return Self

METHOD InsertPopUp( Caption, Name, checked, disabled, Parent, hilited, Image, ;
                    lRight, lStretch, nBreak, nPos ) CLASS TMenuItem

   LOCAL nStyle

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   ::Register( CreatePopupMenu(), Name )
   ::xId := ::hWnd
   AADD( _OOHG_xMenuActive, Self )
   nStyle := MF_BYPOSITION + MF_POPUP + MF_STRING + IF( ValType( lRight ) == "L" .AND. lRight, MF_RIGHTJUSTIFY, 0 ) + ;
             IF( ValType( nBreak ) != "N", 0, IF( nBreak == 1, MF_MENUBREAK, MF_MENUBARBREAK ) )
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // Append to the end
   InsertMenu( ::Container:hWnd, ::hWnd, Caption, nStyle, nPos )
   if HB_IsLogical( lStretch ) .AND. lStretch
      ::Stretch := .T.
   EndIf
   ::Picture := image
   ::Checked := checked
   ::Hilited := hilited
   if HB_IsLogical( disabled ) .AND. disabled
      ::Enabled := .F.
   EndIf
   ::lIsPopUp := .T.

   Return Self

METHOD DefineItem( caption, action, name, Image, checked, disabled, Parent, ;
                   hilited, lRight, lStretch, nBreak ) CLASS TMenuItem

   Local nStyle, id

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   Id := _GetId()
   nStyle := MF_STRING + IF( HB_IsLogical( lRight ) .AND. lRight, MF_RIGHTJUSTIFY, 0 ) + ;
             IF( ValType( nBreak ) != "N", 0, IF( nBreak == 1, MF_MENUBREAK, MF_MENUBARBREAK ) )
   AppendMenu( ::Container:hWnd, id, caption, nStyle )
   ::Register( 0, Name, , , , Id )
   ::xId := ::Id
   ::OnClick := action
   if HB_IsLogical( lStretch ) .AND. lStretch
      ::Stretch := .T.
   EndIf
   ::Picture := image
   ::Checked := checked
   ::Hilited := hilited
   if HB_IsLogical( disabled )  .AND. disabled
      ::Enabled := .F.
   EndIf

   Return Self

METHOD InsertItem( caption, action, name, Image, checked, disabled, Parent, ;
                   hilited, lRight, lStretch, nBreak, nPos ) CLASS TMenuItem

   Local nStyle, id

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   Id := _GetId()
   nStyle := MF_BYPOSITION + MF_STRING + IF( HB_IsLogical( lRight ) .AND. lRight, MF_RIGHTJUSTIFY, 0 ) + ;
             IF( ValType( nBreak ) != "N", 0, IF( nBreak == 1, MF_MENUBREAK, MF_MENUBARBREAK ) )
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // Append to the end
   InsertMenu( ::Container:hWnd, id, caption, nStyle, nPos )
   ::Register( 0, Name, , , , Id )
   ::xId := ::Id
   ::OnClick := action
   if HB_IsLogical( lStretch ) .AND. lStretch
      ::Stretch := .T.
   EndIf
   ::Picture := image
   ::Checked := checked
   ::Hilited := hilited
   if HB_IsLogical( disabled )  .AND. disabled
      ::Enabled := .F.
   EndIf

   Return Self

METHOD DefineSeparator( name, Parent, lRight ) CLASS TMenuItem

   Local nStyle, id

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   Id := _GetId()
   nStyle := MF_SEPARATOR + IF( HB_IsLogical( lRight ) .AND. lRight, MF_RIGHTJUSTIFY, 0 )
   //   AppendMenu( ::Container:hWnd, id, nStyle )
   AppendMenu( ::Container:hWnd, Id, Nil, nStyle )
   ::Register( 0, Name, , , , Id )
   ::xId := ::Id

   Return Self

METHOD InsertSeparator( name, Parent, lRight, nPos ) CLASS TMenuItem

   Local nStyle, id

   If Empty( Parent )
      Parent := ATAIL( _OOHG_xMenuActive )
   EndIf
   ::SetForm( Name, Parent )
   Id := _GetId()
   nStyle := MF_BYPOSITION + MF_SEPARATOR + IF( HB_IsLogical( lRight ) .AND. lRight, MF_RIGHTJUSTIFY, 0 )
   ASSIGN nPos VALUE nPos TYPE "N" DEFAULT -1       // Append to the end
   InsertMenu( ::Container:hWnd, id, Nil, nStyle, nPos )
   ::Register( 0, Name, , , , Id )
   ::xId := ::Id

   Return Self

METHOD Enabled( lEnabled ) CLASS TMenuItem

   Local lRet

   lRet := MenuEnabled( ::Container:hWnd, ::xId, lEnabled )
   ::Container:Refresh()

   Return lRet

METHOD Checked( lChecked ) CLASS TMenuItem

   Local lRet

   lRet := MenuChecked( ::Container:hWnd, ::xId, lChecked )
   ::Container:Refresh()

   Return lRet

METHOD Hilited( lHilited ) CLASS TMenuItem

   Local lRet

   lRet := MenuHilited( ::Container:hWnd, ::xId, lHilited, ::Parent:hWnd )
   ::Container:Refresh()

   Return lRet

METHOD Caption( cCaption ) CLASS TMenuItem

   Local cRet

   cRet := MenuCaption( ::Container:hWnd, ::xId, cCaption )
   ::Container:Refresh()

   Return cRet

METHOD Picture( Images ) CLASS TMenuItem

   If HB_IsArray( Images )
      If LEN( Images ) > 1
         // Change checked bitmap
         If VALTYPE( Images[2] ) # "CM"
            ::aPicture[2] := Images[2]
         Else
            ::aPicture[2] := ""
         EndIf
      EndIf

      If LEN( Images ) > 0
         // Change unchecked bitmap
         If VALTYPE( Images[1] ) # "CM"
            ::aPicture[1] := Images[1]
         Else
            ::aPicture[1] := ""
         Endif
      EndIf
   ElseIf VALTYPE( Images ) $ "CM"
      // Change unchecked bitmap only
      ::aPicture[1] := Images
   Else
      Return ::aPicture
   Endif

   // Release old images
   If ::hBitMaps[1] != nil
     DeleteObject( ::hBitMaps[1] )
     ::hBitMaps[1] := nil
   Endif
   If ::hBitMaps[2] != nil
     DeleteObject( ::hBitMaps[2] )
     ::hBitMaps[2] := nil
   Endif

   ::hBitMaps := MenuItem_SetBitMaps( ::Container:hWnd, ::xId, ::aPicture[1], ::aPicture[2], ::lStretch, OSisWinVISTAorLater() )

   Return ::aPicture

METHOD Stretch( lStretch ) CLASS TMenuItem

   /*
   When .F. (default behavior)
      XP clips big images to expected size (defined by system metrics' parameters
      SM_CXMENUCHECK and SM_CYMENUCHECK, usually 13x13 pixels).
      Vista and Win7 show big images at their real size.
   When .T.
     XP, Vista and Win7 scale down big images to expected size.
   */
   If HB_IsLogical( lStretch )
      If lStretch != ::lStretch
         ::lStretch := lStretch
         ::Picture(::aPicture)
      Endif
   EndIf

   Return ::lStretch

METHOD Release() CLASS TMenuItem

   // Release bitmaps
   If ::hBitMaps[1] != nil
     DeleteObject( ::hBitMaps[1] )
     ::hBitMaps[1] := nil
   Endif
   If ::hBitMaps[2] != nil
     DeleteObject( ::hBitMaps[2] )
     ::hBitMaps[2] := nil
   Endif

   DeleteMenu( ::Container:hWnd, ::xId )
   ::Container:Refresh()

   Return ::Super:Release()

METHOD EndPopUp() CLASS TMenuItem

   Local nPos

   nPos := ASCAN( _OOHG_xMenuActive, { |o| o:hWnd == ::hWnd } )
   IF nPos > 0
      ADEL( _OOHG_xMenuActive, nPos )
      ASIZE( _OOHG_xMenuActive, LEN( _OOHG_xMenuActive ) - 1 )
   ENDIF

   Return Nil

METHOD SetItemsColor( uColor, lApplyToSubItems ) CLASS TMenuItem

   IF ::lIsPopUp
      TMenuItemSetItemsColor( Self, uColor, lApplyToSubItems )
   ENDIF

   Return Nil

METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TMenuItem

   Local aNew, uCargo

   IF ::Cargo == NIL .AND. ::Container:Cargo == NIL .AND. ::Parent:Cargo == NIL
      aNew := aParams
   ELSE
      IF aParams == NIL
         aNew := {}
      ELSEIF HB_IsArray( aParams )
         aNew := aClone( aParams )
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
      aSize( aNew, Len( aNew ) + 1 )
      aIns( aNew, 1 )
      aNew[ 1 ] := uCargo
   ENDIF

   Return ::Super:DoEvent( bBlock, cEventType, aNew )

Function _EndMenuPopup()

   IF LEN( _OOHG_xMenuActive ) > 0
      ATAIL( _OOHG_xMenuActive ):EndPopUp()
   ENDIF

   Return Nil


EXTERN TrackPopUpMenu, SetMenuDefaultItem, GetMenuBarHeight

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

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
#include "oohg.h"

HB_FUNC( TRACKPOPUPMENU )
{
   HWND hwnd = HWNDparam( 4 );

   SetForegroundWindow( hwnd );
   TrackPopupMenu( HMENUparam( 1 ), 0, hb_parni( 2 ), hb_parni( 3 ), 0, hwnd, 0 );
   PostMessage( hwnd, WM_NULL, 0, 0 );
}

HB_FUNC( INSERTMENU )
{
   hb_retnl( InsertMenu( HMENUparam( 1 ), hb_parni( 5 ), hb_parni( 4 ), hb_parni( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( APPENDMENU )
{
   hb_retnl( AppendMenu( HMENUparam( 1 ), hb_parni( 4 ), hb_parni( 2 ), hb_parc( 3 ) ) );
}

HB_FUNC( CREATEMENU )
{
   HMENUret( CreateMenu() );
}

HB_FUNC( CREATEPOPUPMENU )
{
   HMENUret( CreatePopupMenu() );
}

HB_FUNC( SETMENU )
{
   SetMenu( HWNDparam( 1 ), HMENUparam( 2 ) );
}

HB_FUNC( MENUCHECKED )
{
   HMENU hMenu = HMENUparam( 1 );
   int iItem = hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      CheckMenuItem( hMenu, iItem, MF_BYCOMMAND | ( hb_parl( 3 ) ? MF_CHECKED : MF_UNCHECKED ) );
   }

   hb_retl( ( GetMenuState( hMenu, iItem, MF_BYCOMMAND ) & MF_CHECKED ) );
}

HB_FUNC( MENUENABLED )
{
   HMENU hMenu = HMENUparam( 1 );
   int iItem = hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      EnableMenuItem( hMenu, iItem, MF_BYCOMMAND | ( hb_parl( 3 ) ? MF_ENABLED : MF_GRAYED ) );
   }

   hb_retl( ! ( GetMenuState( hMenu, iItem, MF_BYCOMMAND ) & MF_GRAYED ) );
}

HB_FUNC( MENUHILITED )
{
   HMENU hMenu = HMENUparam( 1 );
   int iItem = hb_parni( 2 );

   if( HB_ISLOG( 3 ) )
   {
      HiliteMenuItem( HWNDparam( 4 ), hMenu, iItem, MF_BYCOMMAND | ( hb_parl( 3 ) ? MF_HILITE : MF_UNHILITE ) );
   }

   hb_retl( ( GetMenuState( hMenu, iItem, MF_BYCOMMAND ) & MF_HILITE ) );
}

HB_FUNC( MENUCAPTION )
{
   HMENU hMenu = HMENUparam( 1 );
   int iItem = hb_parni( 2 );
   int iLen;
   char *cBuffer;

   if( HB_ISCHAR( 3 ) )
   {
      MENUITEMINFO MenuItem;
      memset( &MenuItem, 0, sizeof( MenuItem ) );
      MenuItem.cbSize = sizeof( MenuItem );
      MenuItem.fMask = MIIM_STRING;
      MenuItem.dwTypeData = ( char * ) hb_parc( 3 );
      MenuItem.cch = hb_parclen( 3 );
      SetMenuItemInfo( hMenu, iItem, MF_BYCOMMAND, &MenuItem );
   }

   iLen = GetMenuString( hMenu, iItem, NULL, 0, MF_BYCOMMAND );
   cBuffer = (char *) hb_xgrab( iLen + 2 );
   iLen = GetMenuString( hMenu, iItem, cBuffer, iLen + 1, MF_BYCOMMAND );
   hb_retclen( cBuffer, iLen );
   hb_xfree( cBuffer );
}

HB_FUNC( MENUITEM_SETBITMAPS )
{
/*
TODO: detect AERO and set background color accordingly
*/
   HMENU hMenu = HMENUparam( 1 );
   HBITMAP himage1, himage2;
   int iAttributes;
   int nWidth = 0;
   int nHeight = 0;

   if( hb_parl( 6 ) )
   {
      iAttributes = LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT;
   }
   else
   {
      iAttributes = LR_LOADMAP3DCOLORS;
   }

   if( HB_ISLOG( 5 ) )
   {
      if( hb_parl( 5 ) )
      {
         nWidth = GetSystemMetrics(SM_CXMENUCHECK);
         nHeight = GetSystemMetrics(SM_CYMENUCHECK);
      }
   }

   himage1 = (HBITMAP) _OOHG_LoadImage( ( char * ) hb_parc( 3 ), iAttributes, nWidth, nHeight, NULL, GetSysColor( COLOR_MENU ), FALSE );
   himage2 = (HBITMAP) _OOHG_LoadImage( ( char * ) hb_parc( 4 ), iAttributes, nWidth, nHeight, NULL, GetSysColor( COLOR_MENU ), FALSE );

   SetMenuItemBitmaps( hMenu, hb_parni( 2 ), MF_BYCOMMAND, himage1, himage2 );

   hb_reta( 2 );
   HB_STORNL( ( LONG ) himage1, -1, 1 );
   HB_STORNL( ( LONG ) himage2, -1, 2 );
}

HB_FUNC( SETMENUDEFAULTITEM )
{
   HMENU hMenu = HMENUparam( 1 );

   if( ValidHandler( hMenu ) )
   {
      SetMenuDefaultItem( hMenu, hb_parni( 2 ) - 1, TRUE );
   }
}

HB_FUNC( GETMENUBARHEIGHT )
{
   hb_retni( GetSystemMetrics( SM_CYMENU ) );
}

HB_FUNC( DESTROYMENU )
{
   HMENU hMenu = HMENUparam( 1 );

   if( ValidHandler( hMenu ) )
   {
      DestroyMenu( hMenu );
   }
}

HB_FUNC( DRAWMENUBAR )
{
   HWND hWnd = HWNDparam( 1 );

   if( ValidHandler( hWnd ) )
   {
      DrawMenuBar( hWnd );
   }
}

HB_FUNC( DELETEMENU )
{
   HMENU hMenu = HMENUparam( 1 );

   if( ValidHandler( hMenu ) )
   {
      DeleteMenu( hMenu, hb_parni( 2 ), MF_BYCOMMAND );
   }
}

HB_FUNC_STATIC( TMENU_SETMENUBARCOLOR )           // METHOD SetMenuBarColor( uColor, lApplyToSubMenus ) CLASS TMenu
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   COLORREF Color;
   MENUINFO iMenuInfo;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : (COLORREF) oSelf->lBackColor;

         GetMenuInfo( (HMENU) oSelf->hWnd, &iMenuInfo );

         iMenuInfo.cbSize  = sizeof( MENUINFO );
         iMenuInfo.hbrBack = CreateSolidBrush( Color );
         iMenuInfo.fMask   = MIM_BACKGROUND;
         if( hb_parl( 2 ) )
         {
            iMenuInfo.fMask |= MIM_APPLYTOSUBMENUS;
         }

         if( SetMenuInfo( (HMENU) oSelf->hWnd, &iMenuInfo ) )
         {
            DrawMenuBar( HWNDparam( 3 ) );
         }
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC( TMENUITEMSETITEMSCOLOR )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   COLORREF Color;
   MENUINFO iMenuInfo;

   if( _OOHG_DetermineColorReturn( hb_param( 2, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 2 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : (COLORREF) oSelf->lBackColor;

         GetMenuInfo( (HMENU) oSelf->hWnd, &iMenuInfo );

         iMenuInfo.cbSize  = sizeof( MENUINFO );
         iMenuInfo.hbrBack = CreateSolidBrush( Color );
         iMenuInfo.fMask   = MIM_BACKGROUND;
         if( hb_parl( 3 ) )
         {
            iMenuInfo.fMask |= MIM_APPLYTOSUBMENUS;
         }

         if( SetMenuInfo( (HMENU) oSelf->hWnd, &iMenuInfo ) )
         {
            DrawMenuBar( oSelf->hWnd );
         }
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

#pragma ENDDUMP
