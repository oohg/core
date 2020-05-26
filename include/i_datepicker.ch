/*
 * $Id: i_datepicker.ch $
 */
/*
 * ooHG source code:
 * Datepicker definitions
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


#command @ <row>, <col> DATEPICKER <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ VALUE <v> ] ;
      [ FIELD <field> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <shownone: SHOWNONE> ] ;
      [ <updown: UPDOWN> ] ;
      [ <rightalign: RIGHTALIGN> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <disabled: DISABLED> ] ;
      [ <noborder: NOBORDER> ] ;
      [ <rtl: RTL> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <dummy2: RANGE> <min>, <max> ] ;
      [ DATEFORMAT <cDateFormat> ] ;
      [ VALID <valid> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TDatePick(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <v>, ;
            <fontname>, <fontsize>, <tooltip>, <{change}>, <{lostfocus}>, ;
            <{gotfocus}>, <.shownone.>, <.updown.>, <.rightalign.>, <helpid>, ;
            <.invisible.>, <.notabstop.>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <(field)>, <{enter}>, <.rtl.>, <.disabled.>, ;
            <.noborder.>, <min>, <max>, <cDateFormat>, <{valid}> )

#command @ <row>, <col> TIMEPICKER <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ VALUE <v> ] ;
      [ FIELD <field> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <shownone: SHOWNONE> ] ;
      [ <updown: UPDOWN> ] ;
      [ <rightalign: RIGHTALIGN> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <disabled: DISABLED> ] ;
      [ <noborder: NOBORDER> ] ;
      [ <rtl: RTL> ] ;
      [ SUBCLASS <subclass> ] ;
      [ TIMEFORMAT <cTimeFormat> ] ;
      [ VALID <valid> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TTimePick(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <v>, ;
            <fontname>, <fontsize>, <tooltip>, <{change}>, <{lostfocus}>, ;
            <{gotfocus}>, <.shownone.>, .T., .F., <helpid>, ;
            <.invisible.>, <.notabstop.>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <(field)>, <{enter}>, <.rtl.>, <.disabled.>, ;
            <.noborder.>, <cTimeFormat>, <{valid}> )
