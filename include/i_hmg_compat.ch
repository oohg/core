/*
 * $Id: i_hmg_compat.ch,v 1.36 2014-08-13 23:36:13 fyurisich Exp $
 */
/*
 * ooHG source code:
 * HGM Extended compatibility commands
 *
 * Copyright 2007-2014 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2014, http://www.harbour-project.org/
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
 * along with this software; see the file COPYING.TXT.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301,USA (or download from http://www.gnu.org/licenses/).
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

#xtranslate RANDOM( <arg1> ) ;
   => ;
      HB_Random( <arg1> )

#xtranslate Application.ArgC                => TApplication():ArgC
#xtranslate Application.Args                => TApplication():Args
#xtranslate Application.BackColor           => TApplication():BackColor
#xtranslate Application.BackColor := <arg>  => TApplication():BackColor( <arg> )
#xtranslate Application.Col                 => TApplication():Col
#xtranslate Application.Col := <arg>        => TApplication():Col( <arg> )
#xtranslate Application.Cursor := <arg>     => TApplication():Cursor( <arg> )
#xtranslate Application.Drive               => TApplication():Drive
#xtranslate Application.ExeName             => TApplication():ExeName
#xtranslate Application.FormName            => TApplication():MainName
#xtranslate Application.Handle              => TApplication():Handle
#xtranslate Application.Height              => TApplication():Height
#xtranslate Application.Height := <arg>     => TApplication():Height( <arg> )
#xtranslate Application.HelpButton          => TApplication():HelpButton
#xtranslate Application.HelpButton := <arg> => TApplication():HelpButton( <arg> )
#xtranslate Application.Name                => TApplication():Name
#xtranslate Application.Path                => TApplication():Path
#xtranslate Application.Row                 => TApplication():Row
#xtranslate Application.Row := <arg>        => TApplication():Row( <arg> )
#xtranslate Application.Title               => TApplication():Title
#xtranslate Application.Title := <arg>      => TApplication():Title( <arg> )
#xtranslate Application.Topmost             => TApplication():Topmost
#xtranslate Application.Topmost := <arg>    => TApplication():Topmost( <arg> )
#xtranslate Application.Width               => TApplication():Width
#xtranslate Application.Width := <arg>      => TApplication():Width( <arg> )

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

#xcommand BREAK <break> ;
   => ;
      _OOHG_ActiveControlBreak := <break>

#define PICTALIGNMENT //

/*---------------------------------------------------------------------------
SPLITBOX VERSION
---------------------------------------------------------------------------*/

#command BROWSE <name> ;
      [ <dummy01: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ WORKAREA <workarea> ] ;
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
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy05: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ <dummy06: ONCLICK, ON CLICK> <click> ] ;
      [ <edit: EDIT> ] ;
      [ <inplace: INPLACE> ] ;
      [ <append: APPEND> ] ;
      [ <dummy07: ONHEADCLICK, ON HEADCLICK> <aHeadClick> ] ;
      [ <dummy08: WHEN, COLUMNWHEN> <aWhenFields> ] ;
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
      [ <rtl: RTL> ] ;
      [ <dummy09: ONAPPEND, ON APPEND> <onappend> ] ;
      [ <dummy10: ONEDITCELL, ON EDITCELL> <editcell> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ REPLACEFIELD <replacefields> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <reccount: RECCOUNT> ] ;
      [ COLUMNINFO <columninfo> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ <disabled: DISABLED> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <descending: DESCENDING> ] ;
      [ DELETEWHEN <bWhenDel> ] ;
      [ DELETEMSG <DelMsg> ] ;
      [ <dummy12: ONDELETE, ON DELETE> <onDelete> ] ;
      [ HEADERIMAGES <aHeaderImages> ] ;
      [ IMAGESALIGN <aImgAlign> ] ;
      [ <fullmove: FULLMOVE> ] ;
      [ SELECTEDCOLORS <aSelectedColors> ] ;
      [ EDITKEYS <aEditKeys> ] ;
      [ <forcerefresh: FORCEREFRESH> ] ;
      [ <norefresh: NOREFRESH> ] ;
      [ <bffr: DOUBLEBUFFER, SINGLEBUFFER> ] ;
      [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
      [ <plm: PAINTLEFTMARGIN> ] ;
      [ <sync: SYNCHRONIZED, UNSYNCHRONIZED> ] ;
      [ <fixedcols: FIXEDCOLS> ] ;
      [ <nodelmsg: NODELETEMSG> ] ;
      [ <updall: UPDATEALL> ] ;
      [ <dummy13: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
      [ <fixedwidths: FIXEDWIDTHS> ] ;
      [ <blocks: FIXEDBLOCKS, DYNAMICBLOCKS> ] ;
      [ BEFORECOLMOVE <bBefMov> ] ;
      [ AFTERCOLMOVE <bAftMov> ] ;
      [ BEFORECOLSIZE <bBefSiz> ] ;
      [ AFTERCOLSIZE <bAftSiz> ] ;
      [ BEFOREAUTOFIT <bBefAut> ] ;
      [ <excel: EDITLIKEEXCEL> ] ;
      [ <buts: USEBUTTONS> ] ;
      [ <upcol: UPDATECOLORS> ] ;
      [ <edtctrls: FIXEDCONTROLS, DYNAMICCONTROLS> ] ;
      [ <dummy14: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
      [ <extdbl: EXTDBLCLICK> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TOBrowse(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, , , <w>, <h>, <headers>, <widths>, ;
            <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, <{change}>, ;
            <{dblclick}>, <aHeadClick>, <{gotfocus}>, <{lostfocus}>, ;
            <(workarea)>, <.delete.>, <.style.>, <aImage>, <aJust>, <helpid>, ;
            <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, <.break.>, ;
            <backcolor>, <fontcolor>, <.lock.>, <.inplace.>, <.novscroll.>, ;
            <.append.>, <aReadOnly>, <aValidFields>, <aValidMessages>, ;
            <.edit.>, <dynamicbackcolor>, <aWhenFields>, <dynamicforecolor>, ;
            <Picture>, <.rtl.>, <{onappend}>, <{editcell}>, <editcontrols>, ;
            <replacefields>, <.reccount.>, <columninfo>, ! <.noshowheaders.>, ;
            <{enter}>, <.disabled.>, <.notabstop.>, <.invisible.>, ;
            <.descending.>, <{bWhenDel}>, <DelMsg>, <{onDelete}>, ;
            <aHeaderImages>, <aImgAlign>, <.fullmove.>, <aSelectedColors>, ;
            <aEditKeys>, ;
            IIF( <.forcerefresh.>, 0, IIF( <.norefresh.>, 1, NIL ) ), ;
            IIF( Upper( #<bffr> ) == "DOUBLEBUFFER", .T., ;
            IIF( Upper( #<bffr> ) == "SINGLEBUFFER", .F., .T. ) ), ;
            IIF( Upper( #<focus> ) == "NOFOCUSRECT", .F., ;
            IIF( Upper( #<focus> ) == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, ;
            IIF( Upper( #<sync> ) == "UNSYNCHRONIZED", .F., ;
            IIF( Upper( #<sync> ) == "SYNCHRONIZED", .T., NIL ) ), ;
            <.fixedcols.>, <.nodelmsg.>, <.updall.>, <{abortedit}>, <{click}>, ;
            <.fixedwidths.>, ;
            IIF( Upper( #<blocks> ) == "FIXEDBLOCKS", .T., ;
            IIF( Upper( #<blocks> ) == "DYNAMICBLOCKS", .F., NIL ) ), ;
            <{bBefMov}>, <{bAftMov}>, <{bBefSiz}>, <{bAftSiz}>, <{bBefAut}>, ;
            <.excel.>, <.buts.>, <.upcol.>, ;
            IIF( Upper( #<edtctrls> ) == "FIXEDCONTROLS", .T., ;
            IIF( Upper( #<edtctrls> ) == "DYNAMICCONTROLS", .F., NIL ) ), ;
            <{bheadrclick}>, <.extdbl.> )

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
      [ <ladjust: AUTOFIT, ADJUST> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;                                
      [ FONTCOLOR <fontcolor> ] ;                                
      [ <nohotlight: NOHOTLIGHT> ] ;
      [ <flat: FLAT> ] ;
      [ <notrans: NOLOADTRANSPARENT > ] ;
      [ <noxpstyle: NOXPSTYLE > ] ;                              
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
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
      [ <alignment:LEFT,RIGHT,TOP,BOTTOM,CENTER> ] ;
      [ <multiline: MULTILINE> ] ;
      [ <themed: THEMED> ] ;
      [ IMAGEMARGIN <aImageMargin> ] ;
      [ <no3dcolors: NO3DCOLORS> ] ;
      [ <lDIB: DIBSECTION> ] ;
   => ;
      @ <row>, <col> BUTTON <name> ;
            [ OBJ <obj> ] ;
            [ PARENT <parent> ] ;
            [ CAPTION <caption> ] ;
            [ PICTURE <bitmap> ] ;
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
            [ <notrans> ] ;
            [ <ladjust> ] ;
            [ ON MOUSEMOVE <onmousemove> ] ;
            [ <rtl> ] ;
            [ <noprefix> ] ;
            [ SUBCLASS <subclass> ] ;
            [ <disabled> ] ;
            [ BUFFER <buffer> ] ;
            [ HBITMAP <hbitmap> ] ;
            [ <scale> ] ;
            [ <cancel> ] ;
            [ <alignment> ] ;
            [ <multiline> ] ;
            [ <themed> ] ;
            [ IMAGEMARGIN <aImageMargin> ] ;
            [ <no3dcolors> ] ;
            [ <lDIB> ]

/*
TODO: Try to implement this BUTTONEX clauses
      [ PICTURE <bitmap> ] ;
      [ ICON <icon> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ <nohotlight: NOHOTLIGHT> ] ;
      [ <noxpstyle: NOXPSTYLE > ] ;
      [ <default: DEFAULT> ] ;
*/

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

#endif
