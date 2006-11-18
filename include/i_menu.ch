/*
 * $Id: i_menu.ch,v 1.5 2006-11-18 19:39:51 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Menu definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

        "Harbour GUI framework for Win32"
        Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
        Copyright 2001 Antonio Linares <alinares@fivetech.com>
        www - http://www.harbour-project.org

        "Harbour Project"
        Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#command ENABLE MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Enabled := .T.

#command DISABLE MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Enabled := .F.

#command CHECK MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Checked := .T.

#command UNCHECK MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Checked := .F.

#command HILITE MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Hilited := .T.

#command DEHILITE MENUITEM <control> OF <form>;
	=>;
        GetControlObject( <(control)> , <(form)> ):Hilited := .F.

#xcommand DEFINE MAIN MENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuMain():Define( <(parent)> )

#xcommand DEFINE MAINMENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuMain():Define( <(parent)> )

#xcommand DEFINE CONTEXT MENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuContext():Define( <(parent)> )

#xcommand DEFINE CONTEXTMENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuContext():Define( <(parent)> )

#xcommand DEFINE CONTEXT MENU CONTROL <Control> [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuDropDown():Define( <(Control)> , <(parent)> )

#xcommand DEFINE CONTEXTMENU CONTROL <Control> [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuDropDown():Define( <(Control)> , <(parent)> )

#xcommand DEFINE NOTIFY MENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuNotify():Define( <(parent)> )

#xcommand DEFINE NOTIFYMENU [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuNotify():Define( <(parent)> )

#xcommand POPUP <caption> [ NAME <name> ] [ OBJ <oObj> ] [ <checked:CHECKED> ] [ <disabled:DISABLED> ] [ FROM [ POPUP ] <parent> ] [ <hilited:HILITED> ] [ IMAGE <image> ] [ <right:RIGHT> ] ;
=> ;
[ <oObj> := ] TMenuItem():DefinePopUp( <caption> , <(name)> , <.checked.> , <.disabled.>, <parent>, <.hilited.>, <image>, <.right.> )

#xcommand DEFINE POPUP <caption> [ NAME <name> ] [ OBJ <oObj> ] [ <checked:CHECKED> ] [ <disabled:DISABLED> ] [ FROM [ POPUP ] <parent> ] [ <hilited:HILITED> ] [ IMAGE <image> ] [ <right:RIGHT> ] ;
=> ;
[ <oObj> := ] TMenuItem():DefinePopUp( <caption> , <(name)> , <.checked.> , <.disabled.>, <parent>, <.hilited.>, <image>, <.right.> )

#xcommand DEFINE MENU POPUP <caption> [ NAME <name> ] [ OBJ <oObj> ] [ <checked:CHECKED> ] [ <disabled:DISABLED> ] [ FROM [ POPUP ] <parent> ] [ <hilited:HILITED> ] [ IMAGE <image> ] [ <right:RIGHT> ] ;
=> ;
[ <oObj> := ] TMenuItem():DefinePopUp( <caption> , <(name)> , <.checked.> , <.disabled.>, <parent>, <.hilited.>, <image>, <.right.> )

#xcommand ITEM <caption> [ ACTION <action> ] [ NAME <name> ] [ IMAGE <image> ] [ <checked:CHECKED> ] [ OBJ <oObj> ] [ <disabled:DISABLED> ] [ FROM [ POPUP ] <parent> ] [ <hilited:HILITED> ] [ <right:RIGHT> ] ;
=> ;
[ <oObj> := ] TMenuItem():DefineItem( <caption> , <{action}> , <(name)> , <image> , <.checked.> , <.disabled.>, <parent>, <.hilited.>, <.right.> )

#xcommand MENUITEM <caption> [ ACTION <action> ] [ NAME <name> ] [ IMAGE <image> ] [ <checked:CHECKED> ] [ OBJ <oObj> ] [ <disabled:DISABLED> ] [ FROM [ POPUP ] <parent> ] [ <hilited:HILITED> ] [ <right:RIGHT> ] ;
=> ;
[ <oObj> := ] TMenuItem():DefineItem( <caption> , <{action}> , <(name)> , <image> , <.checked.> , <.disabled.>, <parent>, <.hilited.>, <.right.> )

#xcommand SEPARATOR [ FROM [ POPUP ] <parent> ] ;
=> ;
_DefineSeparator( <parent> )

#xcommand END POPUP ;
=> ;
_EndMenuPopup()

#xcommand END MENU ;
=> ;
_EndMenu()

#xcommand DEFINE DROPDOWN MENU BUTTON <button> [ OF <parent> ] [ OBJ <oObj> ] ;
=>;
[ <oObj> := ] TMenuDropDown():Define( <(button)> , <(parent)> )
