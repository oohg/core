/*
 * $Id: i_hmg_compat.ch $
 */
/*
 * ooHG source code:
 * HGM Extended compatibility commands
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


#ifndef __OOHG_HMG_COMPAT__

#define __OOHG_HMG_COMPAT__

#xtranslate _SetWindowBackColor( <FormHandle>, <aColor> ) ;
   => ;
      GetFormObjectByHandle( <FormHandle> ):BackColor( <aColor> )

#xtranslate CopyToClipboard( [ <x> ] ) ;
   => ;
      SetClipboardText( <x> )

#xtranslate RetrieveTextFromClipboard() ;
   => ;
      GetClipboardText()

#xtranslate Random( <arg1> ) ;
   => ;
      HB_Random( <arg1> )

#xtranslate IsThemed() ;
   => ;
      .T.

#xtranslate GlobalMemoryStatusEx() ;
   => ;
      GlobalMemoryStatus()

#xtranslate GetExeFileName() ;
   => ;
      GetModuleFileName()

#xtranslate IFNIL( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ( <v1> ) == NIL, <exp1>, <exp2> )

#xtranslate IFARRAY( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISARRAY( <v1> ), <exp1>, <exp2> )

#xtranslate IFBLOCK( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISBLOCK( <v1> ), <exp1>, <exp2> )

#xtranslate IFCHARACTER( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISCHARACTER( <v1> ), <exp1>, <exp2> )

#xtranslate IFCHAR( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISCHAR( <v1> ), <exp1>, <exp2> )

#xtranslate IFSTRING( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISSTRING( <v1> ), <exp1>, <exp2> )

#xtranslate IFDATE( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISDATE( <v1> ), <exp1>, <exp2> )

#xtranslate IFLOGICAL( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISLOGICAL( <v1> ), <exp1>, <exp2> )

#xtranslate IFNUMBER( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISNUMBER( <v1> ), <exp1>, <exp2> )

#xtranslate IFNUMERIC( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISNUMERIC( <v1> ), <exp1>, <exp2> )

#xtranslate IFOBJECT( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( ISOBJECT( <v1> ), <exp1>, <exp2> )

#xtranslate IFEMPTY( <v1>, <exp1>, <exp2> ) ;
   => ;
      IIF( EMPTY( <v1> ), <exp1>, <exp2> )

#xtranslate _HMG_ThisFormName ;
   => ;
      _OOHG_ThisForm:Name

/*---------------------------------------------------------------------------
SPLITBOX VERSION
---------------------------------------------------------------------------*/

#xcommand BROWSE <name> ;
      [ OF <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ WORKAREA <workarea> ] ;
      [ FIELDS <Fields> ] ;
      [ VALUE <value> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
      [ DYNAMICFORECOLOR <dynamicforecolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ ON GOTFOCUS <gotfocus> ] ;
      [ ON CHANGE <change> ] ;
      [ ON LOSTFOCUS <lostfocus> ] ;
      [ ON DBLCLICK <dblclick> ] ;
      [ <edit: EDIT> ] ;
      [ <inplace: INPLACE> ] ;
      [ <append: APPEND> ] ;
      [ INPUTITEMS <inputitems> ] ;
      [ DISPLAYITEMS <displayitems> ] ;
      [ ON HEADCLICK <aHeadClick> ] ;
      [ WHEN <aWhenFields> ] ;
      [ VALID <aValidFields> ] ;
      [ VALIDMESSAGES <aValidMessages> ] ;
      [ READONLY <aReadOnly> ] ;
      [ <lock: LOCK> ] ;
      [ <delete: DELETE> ] ;
      [ <style: NOLINES> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ <novscroll: NOVSCROLL> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ HEADERIMAGE <aImageHeader> ] ;
      [ <notabstop: NOTABSTOP> ] ;
   => ;
      TOBrowse():Define( <(name)>, <(parent)>, , , <w>, <h>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, ;
            <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <(workarea)>, <.delete.>, <.style.>, <aImage>, ;
            <aJust>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, <.lock.>, ;
            <.inplace.>, <.novscroll.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, , , ;
            , , , , , , , , , <.notabstop.>, , , , , , <aImageHeader> )

/*
TODO: Try to implement this BROWSE clauses using COLUMNCONTROLS:
      [ INPUTITEMS <inputitems> ] ;
      [ DISPLAYITEMS <displayitems> ] ;
*/

#xcommand @ <row>, <col> BUTTONEX <name> ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ CAPTION <caption> ] ;
      [ <dummy2: PICTURE, ICON> <bitmap> ] ;
      [ <dummy3: ACTION, ON CLICK, ONCLICK> <action> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <font> ] ;
      [ SIZE <size> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ <uptext: UPPERTEXT> ] ;
      [ <autofit: ADJUST> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ <nohotlight: NOHOTLIGHT> ] ;
      [ <flat: FLAT> ] ;
      [ <lnoldtr: NOLOADTRANSPARENT> ] ;
      [ <noxpstyle: NOXPSTYLE> ] ;
      [ <dummy02: ON GOTFOCUS,ON MOUSEHOVER> <gotfocus> ] ;
      [ <dummy04: ON LOSTFOCUS,ON MOUSELEAVE>> <lostfocus> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <default: DEFAULT> ] ;
   => ;
      @ <row>, <col> BUTTON <name> ;
            [ PARENT <parent> ] ;
            [ ACTION <action> ] ;
            [ WIDTH <w> ] ;
            [ HEIGHT <h> ] ;
            [ FONT <font> ] ;
            [ SIZE <size> ] ;
            [ <bold> ] ;
            [ <italic> ] ;
            [ <underline> ] ;
            [ <strikeout> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ <flat> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ <notabstop> ] ;
            [ HELPID <helpid> ] ;
            [ <invisible> ] ;
            [ CAPTION <caption> ] ;
            [ PICTURE <bitmap> DIBSECTION ] ;
            [ <lnoldtr> ] ;
            BOTTOM ;
            [ <autofit> ] ;
            [ BACKCOLOR <backcolor> ] ;
            [ <nohotlight> ]

#xcommand @ <row>, <col> BUTTONEX <name> ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ CAPTION <caption> ] ;
      [ <dummy2: PICTURE, ICON> <bitmap> ] ;
      [ <dummy3: ACTION, ON CLICK, ONCLICK> <action> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <font> ] ;
      [ SIZE <size> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ <uptext: UPPERTEXT> ] ;
      [ <autofit: ADJUST> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ <nohotlight: NOHOTLIGHT> ] ;
      [ <flat: FLAT> ] ;
      [ <lnoldtr: NOLOADTRANSPARENT> ] ;
      [ <noxpstyle: NOXPSTYLE> ] ;
      [ <dummy02: ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy04: ON LOSTFOCUS> <lostfocus> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <default: DEFAULT> ] ;
      [ <imgalign: RIGHT, TOP, BOTTOM> ] ;
   => ;
      @ <row>, <col> BUTTON <name> ;
            [ PARENT <parent> ] ;
            [ ACTION <action> ] ;
            [ WIDTH <w> ] ;
            [ HEIGHT <h> ] ;
            [ FONT <font> ] ;
            [ SIZE <size> ] ;
            [ <bold> ] ;
            [ <italic> ] ;
            [ <underline> ] ;
            [ <strikeout> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ <flat> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ <notabstop> ] ;
            [ HELPID <helpid> ] ;
            [ <invisible> ] ;
            [ CAPTION <caption> ] ;
            [ PICTURE <bitmap> DIBSECTION ] ;
            [ <lnoldtr> ] ;
            [ <imgalign> ] ;
            [ <autofit> ] ;
            [ BACKCOLOR <backcolor> ] ;
            [ <nohotlight> ]

/*
TODO: Try to implement this BUTTONEX clauses
      [ FONTCOLOR <fontcolor> ] ;
      [ <noxpstyle: NOXPSTYLE> ] ;
      [ <default: DEFAULT> ] ;
*/

#xtranslate BUTTONEX [ <x> ] NOTRANSPARENT ;
   => ;
      BUTTONEX [ <x> ] NOLOADTRANSPARENT

#xtranslate BUTTONEX [ <x> ] LEFTTEXT ;
   => ;
      BUTTONEX [ <x> ] RIGHT

#xtranslate BUTTONEX [ <x> ] VERTICAL ;
   => ;
      BUTTONEX [ <x> ] TOP

#xtranslate BUTTONEX [ <x> ] VERTICAL [ <y> ] UPPERTEXT ;
   => ;
      BUTTONEX [ <x> ] BOTTOM [ <y> ]

#xtranslate BUTTONEX [ <x> ] UPPERTEXT [ <y> ] VERTICAL ;
   => ;
      BUTTONEX [ <x> ] BOTTOM [ <y> ]

#xtranslate <Form> . <Button> . Icon ;
   => ;
      <Form>.<Button>.Picture

#xtranslate @ <row>, <col> BTNTEXTBOX <name> ;
      [ ID <nId> ] ;
      [ <dummy1: OF, PARENT, DIALOG> <parent> ] ;
      [ HEIGHT <height> ] ;
      [ WIDTH <width> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ <dummy2: ACTION, ON CLICK, ONCLICK> <action> ] ;
      [ ACTION2 <action2> ] ;
      [ <dummy3: IMAGE, PICTURE> <abitmap> ] ;
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
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
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
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
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
            [ WIDTH <w> ] ;
            [ HEIGHT <h> ] ;
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

#xtranslate MENUITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate MENUITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate ITEM [ <x> ] IMAGE <image> [ <y> ] CHECKMARK <mark> [ <z> ] ;
   => ITEM [ <x> ] [ <y> ] [ <z> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] CHECKMARK <mark> [ <y> ] IMAGE <image> [ <z> ] ;
   => ITEM [ <x> ] [ <y> ] [ <z> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] ICON <image> CHECKMARK <mark> ;
   => ITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate MENUITEM [ <x> ] IMAGE <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate MENUITEM [ <x> ] ICON <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate _GetSysFont() ;
   => ;
      GetDefaultFontName()

#xtranslate BUTTON [ <x> ] DEFAULT ;
   => ;
      BUTTON [ <x> ]

#xtranslate SET TOOLTIP TEXTCOLOR TO <color> OF <form> ;
   => ;
      SET TOOLTIP TEXTCOLOR TO <color>

#xtranslate SET TOOLTIP BACKCOLOR TO <color> OF <form> ;
   => ;
      SET TOOLTIP BACKCOLOR TO <color>

#xtranslate SET TOOLTIP MAXWIDTH TO <w> OF <form> ;
   => ;
      SET TOOLTIP MAXWIDTH TO <w>

#xtranslate SET TOOLTIP VISIBLETIME TO <t> OF <form> ;
   => ;
      SET TOOLTIP VISIBLETIME TO <t>

#endif
