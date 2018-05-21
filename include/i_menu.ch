/*
 * $Id: i_menu.ch $
 */
/*
 * ooHG source code:
 * Menu definitions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
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


#command ENABLE MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Enabled := .T.

#command DISABLE MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Enabled := .F.

#command CHECK MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Checked := .T.

#command UNCHECK MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Checked := .F.

#command HILITE MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Hilited := .T.

#command DEHILITE MENUITEM <control> OF <form>;
         =>;
         GetControlObject( <(control)>, <(form)> ):Hilited := .F.

#xcommand DEFINE MAIN MENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuMain(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE MAINMENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuMain(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE CONTEXT MENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuContext(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE CONTEXTMENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuContext(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE CONTEXT MENU CONTROL <Control> ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(Control)>, <(parent)>, <(name)> )

#xcommand DEFINE CONTEXTMENU CONTROL <Control> ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(Control)>, <(parent)>, <(name)> )

#xcommand DEFINE DROPDOWN MENU BUTTON <button> ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuDropDown(), [ <subclass>() ] ): ;
            Define( <(button)>, <(parent)>, <(name)> )

#xcommand DEFINE NOTIFY MENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuNotify(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE NOTIFYMENU ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuNotify(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand DEFINE MENU DYNAMIC ;
      [ OF <parent> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ NAME <name> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenu(), [ <subclass>() ] ): ;
            Define( <(parent)>, <(name)> )

#xcommand POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, 1, NIL ) )

#xcommand DEFINE POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, 1, NIL ) )

#xcommand DEFINE MENU POPUP <caption> ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ <checked: CHECKED> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefinePopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, 1, NIL ) )

#xcommand ITEM <caption> ;
      [ ACTION <action> ] ;
      [ NAME <name> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefineItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, IIF( <.separator.>, 2, 1 ), NIL ) )

#xcommand MENUITEM <caption> ;
      [ ACTION <action> ] ;
      [ NAME <name> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            DefineItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, IIF( <.separator.>, 2, 1 ), NIL ) )

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
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            InsertPopUp( <caption>, <(name)>, <.checked.>, <.disabled.>, ;
            <parent>, <.hilited.>, <image>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, 1, NIL ), <nPos> )

#xcommand INSERT ITEM <caption> ;
      [ AT <nPos> ] ;
      [ ACTION <action> ] ;
      [ NAME <name> ] ;
      [ IMAGE <image> [ <stretch: STRETCH> ] ] ;
      [ <checked: CHECKED> ] ;
      [ OBJ <obj> ] ;
      [ <disabled: DISABLED> ] ;
      [ FROM [ POPUP ] <parent> ] ;
      [ <hilited: HILITED> ] ;
      [ <right: RIGHT> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <breakmenu: BREAKMENU> ;
      [ <separator: SEPARATOR> ] ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMenuItem(), [ <subclass>() ] ): ;
            InsertItem( <caption>, <{action}>, <(name)>, <image>, <.checked.>, ;
            <.disabled.>, <parent>, <.hilited.>, <.right.>, <.stretch.>, ;
            IIF( <.breakmenu.>, IIF( <.separator.>, 2, 1 ), NIL ), <nPos> )

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
