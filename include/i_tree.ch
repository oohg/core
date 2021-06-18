/*
 * $Id: i_tree.ch $
 */
/*
 * ooHG source code:
 * Tree control definitions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#xcommand DEFINE TREE <name> ;
      FULLROWSELECT ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ AT <row>, <col> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ VALUE <value> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <own: OWNTOOLTIP> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy05: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ NODEIMAGES <aImgNode> [ ITEMIMAGES <aImgItem> ] ] ;
      [ <itemids: ITEMIDS> ] ;
      [ HELPID <helpid> ] ;
      [ <rtl: RTL> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ <break: BREAK> ] ;
      [ <disabled: DISABLED> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ SELCOLOR <selcolor> ] ;
      [ <selbold: SELBOLD> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <editlabels: EDITLABELS> ] ;
      [ <noHScr: NOHSCROLL> ] ;
      [ <noScr: NOSCROLL> ] ;
      [ <hott: HOTTRACKING> ] ;
      [ <nobuts: NOBUTTONS> ] ;
      [ <drag: ENABLEDRAG> ] ;
      [ <drop: ENABLEDROP> ] ;
      [ TARGET <aTarget> ] ;
      [ <single: SINGLEEXPAND> ] ;
      [ <noborder: BORDERLESS, NOBORDER> ] ;
      [ ON LABELEDIT <labeledit> ] ;
      [ VALID <valid> ] ;
      [ ON CHECKCHANGE <checkchange> ] ;
      [ INDENT <pixels> ] ;
      [ ON DROP <ondrop> ] ;
      [ ON EXPAND <bExpand> ] ;
      [ ON COLLAPSE <bCollapse> ] ;
      [ <redraw: REDRAWONADD> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TTree(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <row>, <col>, <width>, <height>, ;
            <{change}>, <tooltip>, <fontname>, <fontsize>, <{gotfocus}>, ;
            <{lostfocus}>, <{dblclick}>, <.break.>, <value>, <helpid>, ;
            <aImgNode>, <aImgItem>, .T., <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.itemids.>, <.rtl.>, <{enter}>, <.disabled.>, ;
            <.invisible.>, <.notabstop.>, <fontcolor>, <backcolor>, .T., ;
            <.checkboxes.>, <.editlabels.>, <.noHScr.>, <.noScr.>, <.hott.>, ;
            .F., <.nobuts.>, <.drag.>, <.single.>, <.noborder.>, <selcolor>, ;
            <{labeledit}>, <{valid}>, <{checkchange}>, <pixels>, <.selbold.>, ;
            <.drop.>, <aTarget>, <{ondrop}>, <.own.>, <{bExpand}>, ;
            <{bCollapse}>, <.redraw.> )

#xcommand DEFINE TREE <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ AT <row>, <col> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ VALUE <value> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <own: OWNTOOLTIP> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy05: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ NODEIMAGES <aImgNode> [ ITEMIMAGES <aImgItem> ] [ <noBut: NOROOTBUTTON> ] ] ;
      [ <itemids: ITEMIDS> ] ;
      [ HELPID <helpid> ] ;
      [ <rtl: RTL> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ <break: BREAK> ] ;
      [ <disabled: DISABLED> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ SELCOLOR <selcolor> ] ;
      [ <selbold: SELBOLD> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <editlabels: EDITLABELS> ] ;
      [ <noHScr: NOHSCROLL> ] ;
      [ <noScr: NOSCROLL> ] ;
      [ <hott: HOTTRACKING> ] ;
      [ <nobuts: NOBUTTONS> ] ;
      [ <nolines: NOLINES> ] ;
      [ <drag: ENABLEDRAG> ] ;
      [ <drop: ENABLEDROP> ] ;
      [ TARGET <aTarget> ] ;
      [ <single: SINGLEEXPAND> ] ;
      [ <noborder: BORDERLESS, NOBORDER> ] ;
      [ ON LABELEDIT <labeledit> ] ;
      [ VALID <valid> ] ;
      [ <dummy12: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
      [ INDENT <pixels> ] ;
      [ ON DROP <ondrop> ] ;
      [ ON EXPAND <bExpand> ] ;
      [ ON COLLAPSE <bCollapse> ] ;
      [ <redraw: REDRAWONADD> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TTree(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <row>, <col>, <width>, <height>, ;
            <{change}>, <tooltip>, <fontname>, <fontsize>, <{gotfocus}>, ;
            <{lostfocus}>, <{dblclick}>, <.break.>, <value>, <helpid>, ;
            <aImgNode>, <aImgItem>, <.noBut.>, <.bold.>, <.italic.>, ;
            <.underline.>, <.strikeout.>, <.itemids.>, <.rtl.>, <{enter}>, ;
            <.disabled.>, <.invisible.>, <.notabstop.>, <fontcolor>, ;
            <backcolor>, .F., <.checkboxes.>, <.editlabels.>, <.noHScr.>, ;
            <.noScr.>, <.hott.>, <.nolines.>, <.nobuts.>, <.drag.>, ;
            <.single.>, <.noborder.>, <selcolor>, <{labeledit}>, <{valid}>, ;
            <{checkchange}>, <pixels>, <.selbold.>, <.drop.>, <aTarget>, ;
            <{ondrop}>, <.own.>, <{bExpand}>, <{bCollapse}>, <.redraw.> )

#xcommand NODE <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;
   => ;
      _DefineTreeNode (<text>, <aImage>, <id>, <.checked.>, <.readonly.>, ;
            <.bold.>, <.disabled.>, <.nodrag.>, <.autoid.> )

#xcommand DEFINE NODE <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;
   => ;
      _DefineTreeNode (<text>, <aImage>, <id>, <.checked.>, <.readonly.>, ;
            <.bold.>, <.disabled.>, <.nodrag.>, <.autoid.> )

#xcommand END NODE ;
   => ;
      _EndTreeNode()

#xcommand TREEITEM <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;
   => ;
      _DefineTreeItem (<text>, <aImage>, <id>, <.checked.>, <.readonly.>, ;
            <.bold.>, <.disabled.>, <.nodrag.>, <.autoid.> )

#xcommand END TREE ;
   => ;
      _EndTree()
