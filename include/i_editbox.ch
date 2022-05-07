/*
 * $Id: i_editbox.ch $
 */
/*
 * OOHG source code:
 * Editbox definitions
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
STANDARD VERSION
---------------------------------------------------------------------------*/

#command @ <row>, <col> EDITBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ <readonly: READONLY> ] ;
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
      [ <dummy: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <novscroll: NOVSCROLL> ] ;
      [ <nohscroll: NOHSCROLL> ] ;
      [ <rtl: RTL> ] ;
      [ <noborder: NOBORDER> ] ;
      [ FOCUSEDPOS <focusedpos> ] ;
      [ <dummy: ONVSCROLL, ON VSCROLL> <vscroll> ] ;
      [ <dummy: ONHSCROLL, ON HSCROLL> <hscroll> ] ;
      [ <disabled: DISABLED> ] ;
      [ INSERTTYPE <nInsType> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <nocm: NOCONTEXTMENU> ] ;
      [ <undo: UNDO> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TEdit(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <width>, ;
            <height>, <value>, <fontname>, <fontsize>, <tooltip>, <maxlength>, <{gotfocus}>, ;
            <{change}>, <{lostfocus}>, <.readonly.>, .f., <helpid>, ;
            <.invisible.>, <.notabstop.>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <(field)>, <backcolor>, <fontcolor>, <.novscroll.>, ;
            <.nohscroll.>, <.rtl.>, <.noborder.>, <focusedpos>, <{hscroll}>, ;
            <{vscroll}>, <.disabled.>, <nInsType>, <.nocm.>, <.undo.> )

/*---------------------------------------------------------------------------
SPLITBOX VERSION
---------------------------------------------------------------------------*/

#command EDITBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ <readonly: READONLY> ] ;
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
      [ <dummy: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <novscroll: NOVSCROLL> ] ;
      [ <nohscroll: NOHSCROLL> ] ;
      [ <rtl: RTL> ] ;
      [ <noborder: NOBORDER> ] ;
      [ FOCUSEDPOS <focusedpos> ] ;
      [ <dummy: ONVSCROLL, ON VSCROLL> <vscroll> ] ;
      [ <dummy: ONHSCROLL, ON HSCROLL> <hscroll> ] ;
      [ <disabled: DISABLED> ] ;
      [ INSERTTYPE <nInsType> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <nocm: NOCONTEXTMENU> ] ;
      [ <undo: UNDO> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TEdit(), [ <subclass>() ] ): ;
            TEdit():Define( <(name)>, <(parent)>, NIL, NIL, <width>, <height>, <value>, ;
            <fontname>, <fontsize>, <tooltip>, <maxlength>, <{gotfocus}>, <{change}>, ;
            <{lostfocus}>, <.readonly.>, <.break.>, <helpid>, <.invisible.>, ;
            <.notabstop.>, <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
            <(field)>, <backcolor>, <fontcolor>, <.novscroll.>, <.nohscroll.>, ;
            <.rtl.>, <.noborder.>, <focusedpos>, <{hscroll}>, <{vscroll}>, ;
            <.disabled.>, <nInsType>, <.nocm.>, <.undo.> )

