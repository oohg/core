/*
 * $Id: i_controlmisc.ch $
 */
/*
 * OOHG source code:
 * Miscelaneous control definitions
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


/*---------------------------------------------------------------------------
STANDARD CURSORS
---------------------------------------------------------------------------*/

#define IDC_ARROW       32512
#define IDC_IBEAM       32513
#define IDC_WAIT        32514
#define IDC_CROSS       32515
#define IDC_UPARROW     32516
#define IDC_SIZE        32640
#define IDC_ICON        32641
#define IDC_SIZENWSE    32642
#define IDC_SIZENESW    32643
#define IDC_SIZEWE      32644
#define IDC_SIZENS      32645
#define IDC_SIZEALL     32646
#define IDC_NO          32648
#define IDC_HAND        32649
#define IDC_APPSTARTING 32650
#define IDC_HELP        32651

#command SETFOCUS <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'SetFocus' )

#command ADD ITEM <i> TO <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'AddItem', <i> )

#command ADD COLUMN ;
      [ INDEX <index> ] ;
      [ CAPTION <caption> ] ;
      [ WIDTH <width> ] ;
      [ JUSTIFY <justify> ] ;
      TO <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'AddColumn', <index>, <caption>, ;
            <width>, <justify> )

#command DELETE COLUMN [ INDEX ] <index> FROM <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'DeleteColumn', <index> )

#command DELETE ITEM <i> FROM <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'DeleteItem', <i> )

#command DELETE ITEM ALL FROM <control> OF <parent> ;
   => ;
      DoMethod( <(parent)>, <(control)>, 'DeleteAllItems' )

#command ENABLE CONTROL <control> OF <form> ;
   => ;
      SetProperty ( <(form)>, <(control)>, 'Enabled', .T. )

#command SHOW CONTROL <control> OF <form> ;
   => ;
      DoMethod( <(form)>, <(control)>, 'Show' )

#command HIDE CONTROL <control> OF <form> ;
   => ;
      DoMethod( <(form)>, <(control)>, 'Hide' )

#command DISABLE CONTROL <control> OF <form> ;
   => ;
      SetProperty ( <(form)>, <(control)>, 'Enabled', .F. )

#command RELEASE CONTROL <control> OF <form> ;
   => ;
      DoMethod( <(form)>, <(control)>, 'Release' )

#xcommand DEFINE PROPERTY <property> TO [ CONTROL ] [ <control> OF ] <form> VALUE <value> ;
   => ;
      DefineProperty( <(property)>, <(control)>, <(form)>, <value> )

#xcommand MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> <Arg4> ;
   => ;
      SetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, <Arg4> )

#xcommand MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> ( <Arg4> ) <Arg5> ;
   => ;
      SetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, <Arg4>, <Arg5> )

#xcommand FETCH [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> TO <Arg4> ;
   => ;
      <Arg4> := GetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)> )

#xcommand FETCH [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> (<Arg4>) TO <Arg5> ;
   => ;
      <Arg5> := GetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, <Arg4> )

#xcommand MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> .T. ;
   => ;
      SetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, .T. )

#xcommand MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> .F. ;
   => ;
      SetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, .F. )

#xcommand MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> { <Arg4, ...> } ;
   => ;
      SetProperty ( <(Arg1)>, <(Arg2)>, <(Arg3)>, \{<Arg4>\} )

#translate SET MULTIPLE <x: ON, OFF> [<warning: WARNING>] ;
   => ;
      _OOHG_AppObject():Value_Pos30( { <(x)>, <.warning.> } )

#translate SET CONTEXTMENUS OFF ;
   => ;
      _OOHG_ShowContextMenus( .F. )

#translate SET CONTEXTMENUS ON ;
   => ;
      _OOHG_ShowContextMenus( .T. )

#translate SET CONTEXT MENU OFF ;
   => ;
      _OOHG_ShowContextMenus( .F. )

#translate SET CONTEXT MENU ON ;
   => ;
      _OOHG_ShowContextMenus( .T. )

#translate SET SAMEENTERDBLCLICK OFF ;
   => ;
      _OOHG_SameEnterDblClick := .F.

#translate SET SAMEENTERDBLCLICK ON ;
   => ;
      _OOHG_SameEnterDblClick := .T.

#xtranslate SET CONTROL CONTEXTMENUS OFF ;
   => ;
      _OOHG_ShowContextMenus( .F. )

#xtranslate SET CONTROL CONTEXTMENUS ON ;
   => ;
      _OOHG_ShowContextMenus( .T. )

#xtranslate SET CONTROL CONTEXTMENU OFF ;
   => ;
      _OOHG_ShowContextMenus( .F. )

#xtranslate SET CONTROL CONTEXTMENU ON ;
   => ;
      _OOHG_ShowContextMenus( .T. )

#xtranslate SET CONTROL CONTEXT MENU OFF ;
   => ;
      _OOHG_ShowContextMenus( .F. )

#xtranslate SET CONTROL CONTEXT MENU ON ;
   => ;
      _OOHG_ShowContextMenus( .T. )

#xtranslate SET CONTROL <control> OF <parent> CLIENTEDGE ;
   => ;
      ChangeStyle( GetControlHandle( <"control">, <"parent"> ), WS_EX_CLIENTEDGE, NIL, .T. )

#xtranslate SET CONTROL <control> OF <parent> STATICEDGE ;
   => ;
      ChangeStyle( GetControlHandle( <"control">, <"parent"> ), WS_EX_STATICEDGE, NIL, .T. )

#xtranslate SET CONTROL <control> OF <parent> WINDOWEDGE ;
   => ;
      ChangeStyle( GetControlHandle( <"control">, <"parent"> ), WS_EX_WINDOWEDGE, NIL, .T. )

#xtranslate SET CONTROL <control> OF <parent> NOTEDGE ;
   => ;
      ChangeStyle( GetControlHandle( <"control">, <"parent"> ), NIL, hb_bitOr( WS_EX_CLIENTEDGE, WS_EX_STATICEDGE, WS_EX_WINDOWEDGE ), .T. )
