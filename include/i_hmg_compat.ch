/*
 * $Id: i_hmg_compat.ch $
 */
/*
 * OOHG source code:
 * HMG Extended compatibility commands
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


#ifndef __OOHG_HMG_COMPAT__

#define __OOHG_HMG_COMPAT__

#include "i_windefs.ch"

#xtranslate HMG_Is64Bits() ;
   => ;
      IsExe64()

#xtranslate EmptyClipboard( [ <x> ] ) ;
   => ;
      CLEARCLIPBOARD( <x> )

#xtranslate SetClipboard( [ <x> ] ) ;
   => ;
      SETCLIPBOARDTEXT( <x> )

#xtranslate Random( <arg1> ) ;
   => ;
      HMG_Random( <arg1> )

#xtranslate GetClipboard() ;
   => ;
      GETCLIPBOARDTEXT()

#xtranslate GlobalMemoryStatusEx() ;
   => ;
      GlobalMemoryStatus()

#xcommand BROWSE <name> 		;
		[ OF <parent> ] 		;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ WORKAREA <workarea> ]		;
		[ FIELDS <Fields> ] 		;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]  		;
		[ BACKCOLOR <backcolor> ] ;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ INPUTMASK <inputmask> ]	;
		[ FONTCOLOR <fontcolor> ] ;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
		[ WHEN <aWhenFields> ]		;
		[ VALID <aValidFields> ]	;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <delete: DELETE> ]		;
		[ <style: NOLINES> ] 		;
		[ IMAGE <aImage> ] 		;
		[ JUSTIFY <aJust> ] 		;
		[ <novscroll: NOVSCROLL> ] 	;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;
		[ HEADERIMAGES <headerimages> ] ;
   => ;
      TOBrowse():Define( <(name)>, <(parent)>, NIL, NIL, <w>, <h>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, ;
            <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <(workarea)>, <.delete.>, <.style.>, <aImage>, ;
            <aJust>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, <.lock.>, ;
            <.inplace.>, <.novscroll.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, <inputmask>, NIL, ;
            NIL, NIL, NIL, NIL,
            NIL, NIL, NIL, NIL,
            NIL, <.notabstop.>, NIL, NIL,
            NIL, NIL, NIL, <headerimages> )

#xcommand @ <row>,<col> BROWSE <name> 		;
		[ OF <parent> ] 		;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ WORKAREA <workarea> ]	;
		[ FIELDS <Fields> ] 		;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]  		;
		[ BACKCOLOR <backcolor> ] ;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ INPUTMASK <inputmask> ]	;
		[ FORMAT <format> ]	;
		[ INPUTITEMS <inputitems> ]	;
		[ DISPLAYITEMS <displayitems> ]	;
		[ FONTCOLOR <fontcolor> ]	;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
		[ WHEN <aWhenFields> ]		;
		[ VALID <aValidFields> ]	;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <Delete: DELETE> ]		;
		[ <style: NOLINES> ] 		;
		[ IMAGE <aImage> ] 		;
		[ JUSTIFY <aJust> ] 		;
		[ <novscroll: NOVSCROLL> ] 	;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;
		[ HEADERIMAGES <headerimages> ] ;
	=>;
      TOBrowse():Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, ;
            <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <(workarea)>, <.delete.>, <.style.>, <aImage>, ;
            <aJust>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, <.lock.>, ;
            <.inplace.>, <.novsb.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, <inputmask>, NIL, ;
            NIL, NIL, NIL, NIL, ;
            NIL, NIL, NIL, NIL, ;
            NIL, NIL, NIL, NIL, ;
            NIL, NIL, NIL, <headerimages> )

#xtranslate BROWSE [ <x> ] INPUTITEMS <inputitems> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] DISPLAYITEMS <displayitems> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] FORMAT <format> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] INPUTITEMS <inputitems> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] DISPLAYITEMS <displayitems> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] FORMAT <format> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

// desde aca

#xtranslate <Form> . <Button> . Icon ;
   => ;
      <Form>.<Button>.Picture

#xtranslate @ <row>, <col> BTNTEXTBOX <name> ;
      [ ID <nId> ] ;
      [ <dummy: OF, PARENT, DIALOG> <parent> ] ;
      [ HEIGHT <height> ] ;
      [ WIDTH <width> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ <dummy: ACTION, ON CLICK, ONCLICK> <action> ] ;
      [ ACTION2 <action2> ] ;
      [ <dummy: IMAGE, PICTURE> <abitmap> ] ;
      [ BUTTONWIDTH <btnwidth> ] ;
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
      [ <uppercase: UPPERCASE> ] ;
      [ <lowercase: LOWERCASE> ] ;
      [ <numeric: NUMERIC> ] ;
      [ <password: PASSWORD> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy: ONENTER, ON ENTER> <enter> ] ;
      [ <rightalign: RIGHTALIGN> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <readonly: READONLY> ] ;
      [ HELPID <helpid> ] ;
      [ <rtl: RTL> ] ;
      [ OBJ <obj> ] ;
      [ <autoskip: AUTOSKIP> ] ;
      [ <noborder: NOBORDER> ] ;
      [ FOCUSEDPOS <focusedpos> ] ;
      [ <disabled: DISABLED> ] ;
      [ VALID <valid> ] ;
      [ <date: DATE> ] ;
      [ <numeric: NUMERIC> ] ;
      [ INPUTMASK <inputmask> ] ;
      [ FORMAT <format> ] ;
      [ SUBCLASS <subclass> ] ;
      [ WHEN <bWhen> ] ;
   => ;
      @ <row>, <col> TEXTBOX <name> ;
            [ OBJ <obj> ] ;
            [ PARENT <parent> ] ;
            [ HEIGHT <height> ] ;
            [ WIDTH <width> ] ;
            [ FIELD <field> ] ;
            [ VALUE <value> ] ;
            [ <readonly> ] ;
            [ FONT <fontname> ] ;
            [ SIZE <fontsize> ] ;
            [ <bold> ] ;
            [ <italic> ] ;
            [ <underline> ] ;
            [ <strikeout> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ BACKCOLOR <backcolor> ] ;
            [ FONTCOLOR <fontcolor> ] ;
            [ MAXLENGTH <maxlength> ] ;
            [ <uppercase> ] ;
            [ <lowercase> ] ;
            [ <password> ] ;
            [ ON CHANGE <change> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ ON ENTER <enter> ] ;
            [ <rightalign> ] ;
            [ <invisible> ] ;
            [ <notabstop> ] ;
            [ <rtl> ] ;
            [ HELPID <helpid> ] ;
            [ <autoskip> ] ;
            [ <noborder> ] ;
            [ FOCUSEDPOS <focusedpos> ] ;
            [ <disabled> ] ;
            [ VALID <valid> ] ;
            [ <date> ] ;
            [ <numeric> ] ;
            [ INPUTMASK <inputmask> ] ;
            [ FORMAT <format> ] ;
            [ SUBCLASS <subclass> ] ;
            [ ACTION <action> ] ;
            [ ACTION2 <action2> ] ;
            [ IMAGE <abitmap> ] ;
            [ BUTTONWIDTH <btnwidth> ] ;
            [ WHEN <bWhen> ]

#xtranslate DISABLEEDIT ;
   => ;
      READONLY

#xtranslate STATUSITEM [ <x> ] CENTERALIGN ;
   => ;
      STATUSITEM [ <x> ] CENTER

#xtranslate STATUSITEM [ <x> ] RIGHTALIGN ;
   => ;
      STATUSITEM [ <x> ] RIGHT

#xtranslate STATUSITEM [ <x> ] DEFAULT ;
   => ;
      STATUSITEM [ <x> ]

#xtranslate STATUSITEM [ <x> ] FONTCOLOR <fontcolor> ;
   => ;
      STATUSITEM [ <x> ]

#xtranslate STATUSITEM [ <x> ] BACKCOLOR <backcolor> ;
   => ;
      STATUSITEM [ <x> ]

#xtranslate STATUSITEM [ <x> ] STYLE ;
   => ;
      STATUSITEM [ <x> ]

#xcommand @ <row>, <col> GRID <name> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      ROWSOURCE <recordsource> ;
      COLUMNFIELDS <columnfields> ;
      [ ITEMS <rows> ] ;
      [ VALUE <value> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
      [ DYNAMICFORECOLOR <dynamicforecolor> ] ;
      [ ON GOTFOCUS <gotfocus> ] ;
      [ ON CHANGE <change> ] ;
      [ ON LOSTFOCUS <lostfocus> ] ;
      [ ON DBLCLICK <dblclick> ] ;
      [ ON HEADCLICK <aHeadClick> ] ;
      [ <edit: EDIT> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ COLUMNVALID <columnvalid> ] ;
      [ COLUMNWHEN <columnwhen> ] ;
      [ <ownerdata: VIRTUAL> ] ;
      [ ITEMCOUNT <itemcount> ] ;
      [ ON QUERYDATA <dispinfo> ] ;
      [ <multiselect: MULTISELECT> ] ;
      [ <style: NOLINES> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ HEADERIMAGES <headerimages> ] ;
      [ <bycell: NAVIGATEBYCELL> ] ;
      [ <append: APPEND> ] ;
      [ <delete: DELETE> ] ;
      [ DYNAMICDISPLAY <dynamicdisplay> ] ;
      [ ON SAVE <onsave> ] ;
   => ;
      @ <row>, <col> BROWSE <name> ;
            [ PARENT <parent> ] ;
            [ WIDTH <width> ] ;
            [ HEIGHT <height> ] ;
            [ HEADERS <headers> ] ;
            [ WIDTHS <widths> ] ;
            WORKAREA <recordsource> ;
            FIELDS <columnfields> ;
            [ VALUE <value> ] ;
            [ FONT <fontname> ] ;
            [ SIZE <fontsize> ] ;
            [ <bold> ] ;
            [ <italic> ] ;
            [ <underline> ] ;
            [ <strikeout> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ BACKCOLOR <backcolor> ] ;
            [ FONTCOLOR <fontcolor> ] ;
            [ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
            [ DYNAMICFORECOLOR <dynamicforecolor> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON CHANGE <change> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ ON DBLCLICK <dblclick> ] ;
            [ ON HEADCLICK <aHeadClick> ] ;
            [ <edit> INPLACE ] ;
            [ COLUMNCONTROLS <editcontrols> ] ;
            [ VALID <columnvalid> ] ;
            [ COLUMNWHEN <columnwhen> ] ;
            [ ITEMCOUNT <itemcount> ] ;
            [ ON QUERYDATA <dispinfo> ] ;
            [ <style> ] ;
            [ <noshowheaders> ] ;
            [ IMAGE <aImage> ] ;
            [ JUSTIFY <aJust> ] ;
            [ HELPID <helpid> ] ;
            [ <break> ] ;
            [ HEADERIMAGES <headerimages> ] ;
            [ <bycell> ] ;
            [ <append> ] ;
            [ <delete> ] ;

/*
TODO: implement this clauses:
      [ ON SAVE <onsave> ] ;
      [ DYNAMICDISPLAY <dynamicdisplay> ] ;
*/

#xtranslate GRID [ <x> ] LOCKCOLUMNS <lockcolumns> ;
   => GRID [ <x> ] FIXEDCOLS

#xtranslate GRID [ <x> ] LOCKCOLUMNS 0 ;
   => GRID [ <x> ]

#xtranslate GRID [ <x> ] CELLNAVIGATION ;
   => GRID [ <x> ] NAVIGATEBYCELL

#xtranslate GRID [ <x> ] PAINTDOUBLEBUFFER ;
   => GRID [ <x> ]

#xtranslate GRID [ <x> ] ALLOWAPPEND ;
   => GRID [ <x> ] APPEND

#xtranslate GRID [ <x> ] ALLOWDELETE ;
   => GRID [ <x> ] DELETE

#xtranslate @ [ <x> ] DIALOG ;
   => @ [ <x> ] PARENT

#xtranslate ID <nId> [ <x> ] ;
   => [ <x> ]

#xtranslate DEFINE TAB [ <x> ] BACKCOLOR <backcolor> ;
   => DEFINE TAB [ <x> ]

#xtranslate DEFINE TAB [ <x> ] HTFORECOLOR <htforecolor> ;
   => DEFINE TAB [ <x> ]

#xtranslate DEFINE TAB [ <x> ] HTINACTIVECOLOR <htinactivecolor> ;
   => DEFINE TAB [ <x> ]

#xtranslate DEFINE TAB [ <x> ] BOTTOM ;
   => DEFINE TAB [ <x> ]

#command @ <row>, <col> DATEPICKER [ <x> ] BACKCOLOR <backcolor> ;
   => ;
      @ <row>, <col> DATEPICKER [ <x> ]

#command @ <row>, <col> DATEPICKER [ <x> ] FONTCOLOR <fontcolor> ;
   => ;
      @ <row>, <col> DATEPICKER [ <x> ]

#command @ <row>, <col> DATEPICKER [ <x> ] TITLEBACKCOLOR <titlebackclr> ;
   => ;
      @ <row>, <col> DATEPICKER [ <x> ]

#command @ <row>, <col> DATEPICKER [ <x> ] TITLEFONTCOLOR <titlefontclr> ;
   => ;
      @ <row>, <col> DATEPICKER [ <x> ]

#command @ <row>, <col> DATEPICKER [ <x> ] TRAILINGFONTCOLOR <trlfontclr> ;
   => ;
      @ <row>, <col> DATEPICKER [ <x> ]

#xcommand STATUSDATE [ <X> ] ;
   => ;
      DATE [ <X> ]

#xtranslate ITEM [ <x> ] CHECKMARK <mark> ;
   => ITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate ITEM [ <x> ] CHECKMARK <mark> ;
   => ITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate ITEM [ <x> ] IMAGE <image> [ <y> ] CHECKMARK <mark> [ <z> ] ;
   => ITEM [ <x> ] [ <y> ] [ <z> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] CHECKMARK <mark> [ <y> ] IMAGE <image> [ <z> ] ;
   => ITEM [ <x> ] [ <y> ] [ <z> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] ICON <image> CHECKMARK <mark> ;
   => ITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate MENUITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate MENUITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate MENUITEM [ <x> ] IMAGE <image> CHECKED ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

******************************************** ok en adelante

#xtranslate HMG_GarbageCall( [ <x> ] ) ;
   => ;
      CollectGarbage( <x> )

#xtranslate RELEASE MEMORY ;
   => ;
      CollectGarbage() ;;
      EmptyWorkingSet()

#endif
