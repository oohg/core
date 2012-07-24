/*
 * $Id: i_hmg_compat.ch,v 1.16 2012-07-24 23:21:54 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Compatibility commands
 *
 * Copyright 2008 Vicente Guerra <vicente@guerra.com.mx>
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

#ifndef __OOHG_HMG_COMPAT__

#define __OOHG_HMG_COMPAT__

#xtranslate RANDOM( <arg1> )   =>   HB_RANDOM( <arg1> )

#xcommand BREAK <break> ;
   =>;
        _OOHG_ActiveControlBreak         := <break>

#define PICTALIGNMENT //

///////////////////////////////////////////////////////////////////////////////
// SPLITBOX BROWSE
///////////////////////////////////////////////////////////////////////////////
#command BROWSE <name> ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ OBJ <oObj> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ WORKAREA <WorkArea> ] ;
      [ FIELDS <Fields> ] ;
      [ INPUTMASK <Picture> ] ;
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
      [ ON CLICK <click> ] ;
      [ <edit: EDIT> ] ;
      [ <inplace: INPLACE> ] ;
      [ <append: APPEND> ] ;
      [ ON HEADCLICK <aHeadClick> ] ;
      [ <dummy2: WHEN, COLUMNWHEN> <aWhenFields> ] ;
      [ VALID <aValidFields> ] ;
      [ VALIDMESSAGES <aValidMessages> ] ;
      [ READONLY <aReadOnly> ] ;
      [ <lock: LOCK> ] ;
      [ <Delete: DELETE> ] ;
      [ <style: NOLINES> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ <novscroll: NOVSCROLL> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ <rtl: RTL> ] ;
      [ ON APPEND <onappend> ] ;
      [ ON EDITCELL <editcell> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ REPLACEFIELD <replacefields> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <reccount: RECCOUNT> ] ;
      [ COLUMNINFO <columninfo> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ ON ENTER <enter> ] ;
      [ <disabled: DISABLED> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <descending: DESCENDING> ] ;
      [ DELETEWHEN <bWhenDel> ] ;
      [ DELETEMSG <DelMsg> ] ;
      [ ON DELETE <onDelete> ] ;
      [ HEADERIMAGES <aHeaderImages> ] ;
      [ IMAGESALIGN <aImgAlign> ] ;
      [ <fullmove: FULLMOVE> ] ;
      [ SELECTEDCOLORS <aSelectedColors> ] ;
      [ EDITKEYS <aEditKeys> ] ;
      [ <forcerefresh: FORCEREFRESH> ] ;
      [ <norefresh: NOREFRESH> ] ;
      [ <dblbffr: DOUBLEBUFFER> ] ;
      [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
      [ <plm: PAINTLEFTMARGIN> ] ;
      [ <sync: SYNCHRONIZED, UNSYNCHRONIZED> ] ;
      [ <fixedcols: FIXEDCOLS> ] ;
      [ <nodelmsg: NODELETEMSG> ] ;
      [ <updall: UPDATEALL> ] ;
      [ ON ABORTEDIT <abortedit> ] ;
   => ;
      [ <oObj> := ] _OOHG_SelectSubClass( TOBrowse(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, , , <w>, <h>, <headers>, <widths>, <Fields>, ;
            <value>, <fontname>, <fontsize>, <tooltip>, <{change}>, <{dblclick}>, ;
            <aHeadClick>, <{gotfocus}>, <{lostfocus}>, <(WorkArea)>, <.Delete.>, ;
            <.style.>, <aImage>, <aJust>, <helpid>, <.bold.>, <.italic.>, ;
            <.underline.>, <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, ;
            <.lock.>, <.inplace.>, <.novscroll.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, <Picture>, <.rtl.>, <{onappend}>, ;
            <{editcell}>, <editcontrols>, <replacefields>, <.reccount.>, ;
            <columninfo>, ! <.noshowheaders.>, <{enter}>, <.disabled.>, <.notabstop.>, ;
            <.invisible.>, <.descending.>, <{bWhenDel}>, <DelMsg>, <{onDelete}>, ;
            <aHeaderImages>, <aImgAlign>, <.fullmove.>, <aSelectedColors>, <aEditKeys>, ;
            if( <.forcerefresh.>, 0, if( <.norefresh.>, 1, nil ) ), <.dblbffr.>, ;
            iif( upper( #<focus> ) == "NOFOCUSRECT", .F., iif( upper( #<focus> ) == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, iif( upper( #<sync> ) == "UNSYNCHRONIZED", .F., iif( upper( #<sync> ) == "SYNCHRONIZED", .T., NIL ) ), ;
            <.fixedcols.>, <.nodelmsg.>, <.updall.>, <{abortedit}>, <{click}> )


#xcommand @ <row>, <col> BUTTONEX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ CAPTION <caption> ] ;
      [ <dummy2: PICTURE, ICON> <bitmap> ] ;
      [ <dummy3: ACTION,ON CLICK,ONCLICK> <action> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <font> ] ;
      [ SIZE <size> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ <uptext: UPPERTEXT> ] ;
      [ <ladjust: ADJUST> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ <nohotlight: NOHOTLIGHT> ] ;
      [ <flat: FLAT> ] ;
      [ <notrans: NOTRANSPARENT > ] ;
      [ <noxpstyle: NOXPSTYLE > ] ;
      [ ON GOTFOCUS <gotfocus> ] ;
      [ ON LOSTFOCUS <lostfocus> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <default: DEFAULT> ] ;
      [ ON MOUSEMOVE <onmousemove> ] ;
      [ <rtl: RTL> ] ;
      [ <noprefix: NOPREFIX> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <disabled: DISABLED> ] ;
      [ BUFFER <buffer> ] ;
      [ HBITMAP <hbitmap> ] ;
      [ <scale: FORCESCALE> ] ;
      [ <cancel: CANCEL> ] ;
      [ <alignment: LEFT, RIGHT, TOP, BOTTOM> ] ;
      [ <multiline: MULTILINE> ] ;
      [ <themed: THEMED> ] ;
      [ IMAGEMARGIN <aImageMargin> ] ;
   => ;
      @ <row>, <col> BUTTON <name> ;
            [ OBJ <obj> ] ;
            [ PARENT <parent> ] ;
            [ ACTION <action> ];
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
            [ ON MOUSEMOVE <onmousemove> ] ;
            [ <notabstop> ] ;
            [ HELPID <helpid> ]       ;
            [ <invisible> ] ;
            [ <rtl> ] ;
            [ <noprefix> ] ;
            [ SUBCLASS <subclass> ] ;
            [ <disabled> ] ;
            [ CAPTION <caption> ] ;
            [ PICTURE <bitmap> ] ;
            [ BUFFER <buffer> ] ;
            [ HBITMAP <hbitmap> ] ;
            [ <notrans> ] ;
            [ <scale> ] ;
            [ <cancel> ] ;
            [ <alignment> ] ;
            [ <multiline> ] ;
            [ <themed> ] ;
            [ IMAGEMARGIN <aImageMargin> ]

/* TODO:
      [ <nohotlight: NOHOTLIGHT> ];
      [ <noxpstyle: NOXPSTYLE > ] ;
      [ <ladjust: ADJUST> ];
      [ <default: DEFAULT> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
*/


#xtranslate BUTTONEX [ <x> ] LEFTTEXT => BUTTONEX [ <x> ] RIGHT
#xtranslate BUTTONEX [ <x> ] VERTICAL => BUTTONEX [ <x> ] TOP
#xtranslate BUTTONEX [ <x> ] VERTICAL [ <y> ] UPPERTEXT => BUTTONEX [ <x> ] BOTTOM [ <y> ]
#xtranslate BUTTONEX [ <x> ] UPPERTEXT [ <y> ] VERTICAL => BUTTONEX [ <x> ] BOTTOM [ <y> ]
#xtranslate <Form> . <Button> . Icon => <Form>.<Button>.Picture


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
      [ ON CHANGE <change> ] ;
      [ ON GOTFOCUS <gotfocus> ] ;
      [ ON LOSTFOCUS <lostfocus> ] ;
      [ ON ENTER <enter> ] ;
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
            [ <readonly> ];
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


#xtranslate DISABLEEDIT => READONLY


#endif
