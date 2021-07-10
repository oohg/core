/*
 * $Id: i_tab.ch $
 */
/*
 * ooHG source code:
 * TAB control definitions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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


#command DEFINE TAB <name> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      AT <row>, <col> ;
      WIDTH <width> ;
      HEIGHT <height> ;
      [ VALUE <value> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <buttons: BUTTONS> ] ;
      [ <flat: FLAT> ] ;
      [ <hottrack: HOTTRACK> ] ;
      [ <vertical: VERTICAL, LEFT> ] ;
      [ <dummy: ACTION, ONCLICK, ON CLICK> <click> ] ;
      [ <dummy: ONRCLICK, ON RCLICK> <rclick> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <rtl: RTL> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <internals: INTERNALS> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <disabled: DISABLED> ] ;
      [ <multiline: MULTILINE> ] ;
      [ <noproc: DELAYMSGS> ] ;
      [ <right: RIGHT> ] ;
      [ <bottom: BOTTOM> ] ;
      [ <ragged: RAGGEDRIGHT> ] ;
      [ <fwidth: FIXEDWIDTH> ] ;
      [ ITEMSIZE <nw>, <nh> ] ;
      [ MINWIDTH <min> ] ;
      [ PADDING <hor>, <ver> ] ;
      [ <il: ICONLEFT> ] ;
      [ <ll: LABELLEFT> ] ;
      [ <rj: RIGHTJUST> ] ;
      [ <so: SCROLLOP> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TTab(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <width>, <height>, {}, {}, ;
            <value>, <fontname>, <fontsize>, <tooltip>, <{change}>, <.buttons.>, <.flat.>, ;
            <.hottrack.>, <.vertical.>, <.notabstop.>, NIL, <.bold.>, <.italic.>, ;
            <.underline.>, <.strikeout.>, {}, <.rtl.>, <.internals.>, ;
            <.invisible.>, <.disabled.>, <.multiline.>, <.noproc.>, ;
            <.right.>, <.bottom.>, <{rclick}>, <.ragged.>, <.fwidth.>, NIL, ;
            <nw>, <nh>, <min>, <hor>, <ver>, NIL, <.il.>, <.ll.>, <.rj.>, <.so.>, ;
            <{click}> )

#command PAGE <caption> ;
      [ IMAGE <image> ] ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ POSITION <position> ] ;
      [ TOOLTIP <tooltip> ] ;
   => ;
      [ <obj> := ] ;
            _BeginTabPage( <caption>, <image>, [ <position> ], <(name)>, [ <subclass>() ], [ <tooltip> ] )

#command DEFINE PAGE <caption> ;
      [ IMAGE <image> ] ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ POSITION <position> ] ;
      [ TOOLTIP <tooltip> ] ;
   => ;
      [ <obj> := ] ;
            _BeginTabPage( <caption>, <image>, [ <position> ], <(name)>, [ <subclass>() ], [ <tooltip> ] )

#command DEFINE TAB PAGE <caption> ;
      [ IMAGE <image> ] ;
      [ NAME <name> ] ;
      [ OBJ <obj> ] ;
      [ SUBCLASS <subclass> ] ;
      [ POSITION <position> ] ;
      [ TOOLTIP <tooltip> ] ;
   => ;
      [ <obj> := ] ;
            _BeginTabPage( <caption>, <image>, [ <position> ], <(name)>, [ <subclass>() ], [ <tooltip> ] )

#command END PAGE ;
   => ;
      _EndTabPage()

#command END TAB ;
   => ;
      _EndTab()
