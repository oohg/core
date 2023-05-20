/*
 * $Id: i_menu.ch $
 */
/*
 * OOHG source code:
 * Menu definitions
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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


#include "menu.h"

#command ENABLE MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Enabled := .T.

#command DISABLE MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Enabled := .F.

#command CHECK MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Checked := .T.

#command UNCHECK MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Checked := .F.

#command HILITE MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Hilited := .T.

#command DEHILITE MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):Hilited := .F.

#xcommand SET DEFAULT MENUITEM <control> OF <form> ;
   => ;
      GetControlObject( <(control)>, <(form)> ):DefaultItemByID()

#xcommand DEFINE MAIN MENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuMain(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE MAIN MENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):oMenu:Release()

#xcommand DEFINE MAINMENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuMain(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE MAINMENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):oMenu:Release()

#xcommand DEFINE CONTEXT MENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuContext(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTEXT MENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):ContextMenu:Release()

#xcommand DEFINE CONTEXTMENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuContext(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTEXTMENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):ContextMenu:Release()

#xcommand DEFINE CONTEXT MENU CONTROL <control> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(control)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTEXT MENU CONTROL <control> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(control)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE CONTROL CONTEXT MENU <control> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(control)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTROL CONTEXT MENU <control> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(control)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE CONTEXTMENU CONTROL <control> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(control)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTEXTMENU CONTROL <control> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(control)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE CONTROL CONTEXTMENU <control> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(control)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE CONTROL CONTEXTMENU <control> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(control)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE DROPDOWN MENU BUTTON <button> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(button)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE DROPDOWNBUTTON <button> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(button)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE DROPDOWNMENU OWNERBUTTON <button> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(button)>, <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE DROPDOWNMENU OWNERBUTTON <button> <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingControlObject( <(button)>, <(parent)> ):ContextMenu:Release

#xcommand DEFINE NOTIFY MENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuNotify(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE NOTIFY MENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):NotifyMenu:Release()

#xcommand DEFINE NOTIFYMENU ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuNotify(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE NOTIFYMENU <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):NotifyMenu:Release()

#xcommand DEFINE MENU DYNAMIC ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <own: OWNERDRAW> ] ;
      [ <win: WINDRAW> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenu(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)>, <msg>, <fontname>, <tout>, ;
            iif( <.own.>, .T., iif( <.win.>, .F., NIL ) ) )

#xcommand RELEASE MENU DYNAMIC <dummy: OF, PARENT> <parent> ;
   => ;
      GetExistingFormObject( <(parent)> ):DynamicMenu:Release()

#xcommand POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ ON INIT <init> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, 1, NIL ), <msg>, <fontname>, <{init}>, <tout> )

#xcommand DEFINE POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ ON INIT <init> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, 1, NIL ), <msg>, <fontname>, <{init}>, <tout> )

#xcommand DEFINE MENU POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ ON INIT <init> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, 1, NIL ), <msg>, <fontname>, <{init}>, <tout> )

#xcommand ITEM <caption> ;
      [ <dummy: ACTION, ONCLICK> <action> ] ;
      [ NAME <name> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
      [ MESSAGE <msg> ] ;
      [ <default: DEFAULT> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <notrans: NOTRANSPARENT> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefineItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, iif( <.separator.>, 2, 1 ), NIL ), <msg>, ;
            <.default.>, <fontname>, <tout>, <.notrans.> )

#xcommand MENUITEM <caption> ;
      [ <dummy: ACTION, ONCLICK> <action> ] ;
      [ NAME <name> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
      [ MESSAGE <msg> ] ;
      [ <default: DEFAULT> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
      [ <notrans: NOTRANSPARENT> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefineItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, iif( <.separator.>, 2, 1 ), NIL ), <msg>, ;
            <.default.>, <fontname>, <tout>, <.notrans.> )

#xcommand SEPARATOR ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefineSeparator( <(name)>, <parent>, <.right.> )

#xcommand END POPUP ;
   => ;
      _EndMenuPopup()

#xcommand END MENU ;
   => ;
      _EndMenu()

#xcommand INSERT POPUP <caption> ;
      [ AT <nPos> ] ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
      [ MESSAGE <msg> ] ;
      [ FONT <fontname> ] ;
      [ ON INIT <init> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            InsertPopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, 1, NIL ), <nPos>, <msg>, <fontname>, <{init}>, <tout> )

#xcommand INSERT ITEM <caption> ;
      [ AT <nPos> ] ;
      [ <dummy: ACTION, ONCLICK> <action> ] ;
      [ NAME <name> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
      [ MESSAGE <msg> ] ;
      [ <default: DEFAULT> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            InsertItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            iif( <.breakmenu.>, iif( <.separator.>, 2, 1 ), NIL ), <nPos>, ;
            <msg>, <.default.>, <fontname>, <tout> )

#xcommand INSERT SEPARATOR ;
      [ AT <nPos> ] ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            InsertSeparator( <(name)>, <parent>, <.right.>, <nPos> )

#xcommand MRU [ <caption> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ NAME <name> ] ;
      [ <dummy: ACTION, ONCLICK> <funcname> ] ;
      [ <dummy: SIZE, ITEMS> <size> ] ;
      [ <dummy: INI, FILENAME, FILE, DISK> <inifile> ] ;
      [ SECTION <section> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <hilited: HILITED> ] ;
      [ MESSAGE <msg> [, <msg2> ] ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
      [ <default: DEFAULT> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItemMRU(), [ <subclass>() ] ): ;
            Define( <parent>, <name>, <caption>, <(funcname)>, <size>, ;
            <inifile>, <section>, <image>, <.stretch.>, <.hilited.>, <msg>, ;
            <msg2>, iif( <.breakmenu.>, iif( <.separator.>, 2, 1 ), NIL ), ;
            <.default.>, <fontname>, <tout> )

#xcommand MRUITEM [ <caption> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ NAME <name> ] ;
      [ <dummy: ACTION, ONCLICK> <funcname> ] ;
      [ <dummy: SIZE, ITEMS> <size> ] ;
      [ <dummy: INI, FILENAME, FILE, DISK> <inifile> ] ;
      [ SECTION <section> ] ;
      [ <dummy: IMAGE, ICON> <image> [ <stretch: STRETCH> ] ] ;
      [ <hilited: HILITED> ] ;
      [ MESSAGE <msg> [, <msg2> ] ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
      [ <default: DEFAULT> ] ;
      [ FONT <fontname> ] ;
      [ TIMEOUT <tout> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItemMRU(), [ <subclass>() ] ): ;
            Define( <parent>, <name>, <caption>, <(funcname)>, <size>, ;
            <inifile>, <section>, <image>, <.stretch.>, <.hilited.>, <msg>, ;
            <msg2>, iif( <.breakmenu.>, iif( <.separator.>, 2, 1 ), NIL ), ;
            <.default.>, <fontname>, <tout> )

#xcommand SET MENUSTYLE EXTENDED ;
   => ;
      _OOHG_OwnerDrawMenus := .T.

#xcommand SET MENUSTYLE STANDARD ;
   => ;
      _OOHG_OwnerDrawMenus := .F.

#xtranslate IsExtendedMenuStyleActive() ;
   => ;
      _OOHG_OwnerDrawMenus

#xcommand SET MENUCURSOR FULL ;
   => ;
      _OOHG_MenuCursorType( MNUCUR_FULL )

#xcommand SET MENUCURSOR SHORT ;
   => ;
      _OOHG_MenuCursorType( MNUCUR_SHORT )

#xcommand SET MENUSEPARATOR SINGLE LEFTALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_SINGLE, MNUSEP_LEFT )

#xcommand SET MENUSEPARATOR SINGLE CENTERALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_SINGLE, MNUSEP_MIDDLE )

#xcommand SET MENUSEPARATOR SINGLE RIGHTALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_SINGLE, MNUSEP_RIGHT )

#xcommand SET MENUSEPARATOR DOUBLE LEFTALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_DOUBLE, MNUSEP_LEFT )

#xcommand SET MENUSEPARATOR DOUBLE CENTERALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_DOUBLE, MNUSEP_MIDDLE )

#xcommand SET MENUSEPARATOR DOUBLE RIGHTALIGN ;
   => ;
      _OOHG_MenuSeparator( MNUSEP_DOUBLE, MNUSEP_RIGHT )

#xcommand SET MENUITEM BORDER 3D ;
   => ;
      _OOHG_MenuBorderStyle( .T. )

#xcommand SET MENUITEM BORDER 3DSTYLE ;
   => ;
      _OOHG_MenuBorderStyle( .T. )

#xcommand SET MENUITEM BORDER FLAT ;
   => ;
      _OOHG_MenuBorderStyle( .F. )

#xcommand SET MENUGRADIENT VERTICAL ;
   => ;
      _OOHG_MenuGradientStyle( .T. )

#xcommand SET MENUGRADIENT HORIZONTAL ;
   => ;
      _OOHG_MenuGradientStyle( .F. )
