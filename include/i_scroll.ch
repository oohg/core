/*
 * $Id: i_scroll.ch $
 */
/*
 * OOHG source code:
 * ScrollBar control definition
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


#command @ <row>, <col> SCROLLBAR <name> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ HEIGHT <height> ] ;
      [ WIDTH <width> ] ;
      [ RANGE <min>, <max> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONLINEUP, ONLINELEFT, ON LINEUP, ON LINELEFT> <lineup> ] ;
      [ <dummy: ONLINEDOWN, ONLINERIGHT, ON LINEDOWN, ON LINERIGHT> <linedown> ] ;
      [ <dummy: ONPAGEUP, ONPAGELEFT, ON PAGEUP, ON PAGELEFT> <pageup> ] ;
      [ <dummy: ONPAGEDOWN, ONPAGERIGHT, ON PAGEDOWN, ON PAGERIGHT> <pagedown> ] ;
      [ <dummy: ONTOP, ONLEFT, ON TOP, ON LEFT> <top> ] ;
      [ <dummy: ONBOTTOM, ONRIGHT, ON BOTTOM, ON RIGHT> <bottom> ] ;
      [ <dummy: ONTHUMB, ON THUMB> <thumb> ] ;
      [ <dummy: ONTRACK, ON TRACK> <track> ] ;
      [ <dummy: ONENDTRACK, ON ENDTRACK> <endtrack> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <rtl: RTL> ] ;
      [ <horz: HORIZONTAL> ] ;
      [ <vert: VERTICAL> ] ;
      [ <attached: ATTACHED> ] ;
      [ VALUE <value> ] ;
      [ <disabled: DISABLED> ] ;
      [ SUBCLASS <subclass> ] ;
      [ LINESKIP <lineskip> ] ;
      [ PAGESKIP <pageskip> ] ;
      [ <auto: AUTOMOVE> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TScrollBar(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <width>, <height>, ;
            <min>, <max>, <{change}>, <{lineup}>, <{linedown}>, <{pageup}>, ;
            <{pagedown}>, <{top}>, <{bottom}>, <{thumb}>, <{track}>, ;
            <{endtrack}>, <helpid>, <.invisible.>, <tooltip>, <.rtl.>, ;
            iif( <.horz.>, 0, iif( <.vert.>, 1, NIL ) ), <.attached.>, ;
            <value>, <disabled>, <lineskip>, <pageskip>, <.auto.> )
