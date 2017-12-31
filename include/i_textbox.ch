/*
 * $Id: i_textbox.ch $
 */
/*
 * ooHG source code:
 * Textbox definitions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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

#command @ <row>, <col> TEXTBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ HEIGHT <height> ] ;
      [ WIDTH <width> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ < readonly: READONLY > ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ MAXLENGTH <maxlength> ] ;
      [ <upper: UPPERCASE> ] ;
      [ <lower: LOWERCASE> ] ;
      [ <password: PASSWORD> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ ON TEXTFILLED <textfilled> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ <RightAlign: RIGHTALIGN> ] ;
      [ <centeralign: CENTERALIGN> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <rtl: RTL> ] ;
      [ HELPID <helpid> ] ;
      [ <autoskip: AUTOSKIP> ] ;
      [ <noborder: NOBORDER> ] ;
      [ FOCUSEDPOS <focusedpos> ] ;
      [ <disabled: DISABLED> ] ;
      [ VALID <valid> ] ;
      [ < date: DATE > ] ;
      [ DEFAULTYEAR <year> ] ;
      [ <numeric: NUMERIC> ] ;
      [ <dummy2: INPUTMASK, PICTURE> <inputmask> ] ;
      [ FORMAT <format> ] ;
      [ SUBCLASS <subclass> ] ;
      [ ACTION <action> ] ;
      [ ACTION2 <action2> ] ;
      [ IMAGE <abitmap> ] ;
      [ BUTTONWIDTH <btnwidth> ] ;
      [ WHEN <bWhen> ] ;
      [ INSERTTYPE <nInsType> ] ;
   => ;
      [ <obj> := ] DefineTextBox( <(name)>, <(parent)>, <col>, <row>, <width>, ;
            <height>, <value>, <fontname>, <fontsize>, <tooltip>, <maxlength>, ;
            <.upper.>, <.lower.>, <.password.>, <{lostfocus}>, <{gotfocus}>, ;
            <{change}>, <{enter}>, <.RightAlign.>, <helpid>, <.readonly.>, ;
            <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, <(field)>, ;
            <backcolor>, <fontcolor>, <.invisible.>, <.notabstop.>, <.rtl.>, ;
            <.autoskip.>, <.noborder.>, <focusedpos>, <.disabled.>, <{valid}>, ;
            <.date.>, <.numeric.>, <inputmask>, <format>, [ <subclass>() ], ;
            <{action}>, <abitmap>, <btnwidth>, <{action2}>, <{bWhen}>, ;
            <.centeralign.>, <year>, <{textfilled}>, <nInsType> )
