/*
 * $Id: i_browse.ch $
 */
/*
 * ooHG source code:
 * Browse definitions
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


#define REFRESH_FORCE           0
#define REFRESH_NO              1
#define REFRESH_DEFAULT        -1

#define BROWSE_JTFY_LEFT        0
#define BROWSE_JTFY_RIGHT       1
#define BROWSE_JTFY_CENTER      2

#translate MemVar . <AreaName> . <FieldName> ;
   => ;
      MemVar<AreaName><FieldName>

/*---------------------------------------------------------------------------
STANDARD VERSION
---------------------------------------------------------------------------*/

#command @ <row>, <col> BROWSE <name> ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ WORKAREA <workarea> ] ;
      [ FIELDS <Fields> ] ;
      [ INPUTMASK <inputmask> ] ;
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
      [ <dummy: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ <dummy: ACTION, ONCLICK, ON CLICK> <click> ] ;
      [ <edit: EDIT, ALLOWEDIT> ] ;
      [ <inplace: INPLACE> ] ;
      [ <append: APPEND> ] ;
      [ <dummy: ONHEADCLICK, ON HEADCLICK> <aHeadClick> ] ;
      [ <dummy: WHEN, COLUMNWHEN> <aWhenFields> ] ;
      [ <dummy: VALID, COLUMNVALID> <aValidFields> ] ;
      [ VALIDMESSAGES <aValidMessages> ] ;
      [ <nomsg: NODEFAULTMSG> ] ;
      [ READONLY <aReadOnly> ] ;
      [ <lock: LOCK> ] ;
      [ <delete: DELETE> ] ;
      [ <style: NOLINES> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ <novsb: NOVSCROLL, NOVSCROLLBAR> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ <rtl: RTL> ] ;
      [ <dummy: ONAPPEND, ON APPEND> <onappend> ] ;
      [ <dummy: ONEDITCELL, ON EDITCELL> <editcell> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ REPLACEFIELD <replacefields> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <reccount: RECCOUNT> ] ;
      [ COLUMNINFO <columninfo> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ <dummy: ONENTER, ON ENTER> <enter> ] ;
      [ <disabled: DISABLED> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <descending: DESCENDING> ] ;
      [ DELETEWHEN <bWhenDel> ] ;
      [ DELETEMSG <DelMsg> ] ;
      [ <dummy: ONDELETE, ON DELETE> <onDelete> ] ;
      [ HEADERIMAGES <aHeaderImages> ] ;
      [ <dummy: HEADERIMAGESALIGN, IMAGESALIGN> <aImgAlign> ] ;
      [ <fullmove: FULLMOVE> ] ;
      [ SELECTEDCOLORS <aSelectedColors> ] ;
      [ EDITKEYS <aEditKeys> ] ;
      [ EDITKEYSFUN <bFun> ] ;
      [ <forcerefresh: FORCEREFRESH> ] ;
      [ <norefresh: NOREFRESH> ] ;
      [ <bffr: SINGLEBUFFER> ] ;
      [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
      [ <plm: PAINTLEFTMARGIN> ] ;
      [ <sync: SYNCHRONIZED, UNSYNCHRONIZED> ] ;
      [ <fixedcols: FIXEDCOLS> ] ;
      [ <nodelmsg: NODELETEMSG> ] ;
      [ <updall: UPDATEALL> ] ;
      [ <dummy: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
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
      [ <dummy: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
      [ <nomodal: NOMODALEDIT> ] ;
      [ <bycell: NAVIGATEBYCELL> ] ;
      [ <extdbl: EXTDBLCLICK> ] ;
      [ <silent: SILENT> ] ;
      [ <disalta: DISABLEALTA> ] ;
      [ <noshow: NOSHOWALWAYS> ] ;
      [ <none: NONEUNSELS> ] ;
      [ <cbe: CHANGEBEFOREEDIT> ] ;
      [ <dummy: ONRCLICK, ON RCLICK> <rclick> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <dummy: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
      [ <dummy: ONROWREFRESH, ON ROWREFRESH> <rowrefresh> ] ;
      [ DEFAULTVALUES <aDefVal> ] ;
      [ <dummy: ONEDITCELLEND, ON EDITCELLEND> <editend> ] ;
      [ <efv: EDITFIRSTVISIBLE> ] ;
      [ <dummy: ONBEFOREEDITCELL, ON BEFOREEDITCELL> <beforedit> ] ;
      [ EDITCELLVALUE <edtval> ] ;
      [ <klc: KEYSLIKECLIPPER> ] ;
      [ <ctt: CELLTOOLTIP> ] ;
      [ <nohsb: NOHSCROLL, NOHSCROLLBAR> ] ;
      [ <dummy: ONHEADDBLCLICK, ON HEADDBLCLICK> <aHeadDblClick> ] ;
      [ <dummy: HEADERCOLORS, HEADERFONTCOLORS> <aHeadClrs> ] ;
      [ HEADERBACKCOLORS <aHeadBkClrs> ] ;
      [ TIMEOUT <nTime> ] ;
      [ NEWATROW <nRowAt> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( iif( <.bycell.>, TOBrowseByCell(), TOBrowse() ), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <width>, <height>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, ;
            <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <(workarea)>, <.delete.>, <.style.>, <aImage>, ;
            <aJust>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, <.lock.>, ;
            <.inplace.>, <.novsb.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, <inputmask>, <.rtl.>, ;
            <{onappend}>, <{editcell}>, <editcontrols>, <replacefields>, ;
            <.reccount.>, <columninfo>, ! <.noshowheaders.>, <{enter}>, ;
            <.disabled.>, <.notabstop.>, <.invisible.>, <.descending.>, ;
            <{bWhenDel}>, <DelMsg>, <{onDelete}>, <aHeaderImages>, ;
            <aImgAlign>, <.fullmove.>, <aSelectedColors>, <aEditKeys>, ;
            iif( <.forcerefresh.>, 0, iif( <.norefresh.>, 1, NIL ) ), ;
            ! <.bffr.>, ;
            iif( Upper( #<focus> ) == "NOFOCUSRECT", .F., ;
            iif( Upper( #<focus> ) == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, iif( Upper( #<sync> ) == "UNSYNCHRONIZED", .F., ;
            iif( Upper( #<sync> ) == "SYNCHRONIZED", .T., NIL ) ), ;
            <.fixedcols.>, <.nodelmsg.>, <.updall.>, <{abortedit}>, <{click}>, ;
            <.fixedwidths.>, iif( Upper( #<blocks> ) == "FIXEDBLOCKS", .T., ;
            iif( Upper( #<blocks> ) == "DYNAMICBLOCKS", .F., NIL ) ), ;
            <{bBefMov}>, <{bAftMov}>, <{bBefSiz}>, <{bAftSiz}>, <{bBefAut}>, ;
            <.excel.>, <.buts.>, <.upcol.>, ;
            iif( Upper( #<edtctrls> ) == "FIXEDCONTROLS", .T., ;
            iif( Upper( #<edtctrls> ) == "DYNAMICCONTROLS", .F., NIL ) ), ;
            <{bheadrclick}>, <.extdbl.>, <.nomodal.>, <.silent.>, ;
            ! <.disalta.>, <.noshow.>, ;
            <.none.>, <.cbe.>, <{rclick}>, ;
            <.checkboxes.>, <{checkchange}>, <{rowrefresh}>, <aDefVal>, ;
            <{editend}>, ! <.efv.>, <{beforedit}>, <{edtval}>, <.klc.>, ;
            <.ctt.>, <.nohsb.>, <aHeadDblClick>, <aHeadClrs>, <nTime>, ;
            <nRowAt>, <{bFun}>, <.nomsg.>, <aHeadBkClrs> )

#command SET BROWSESYNC ON ;
   => ;
      _OOHG_BrowseSyncStatus := .T.

#command SET BROWSESYNC OFF ;
   => ;
      _OOHG_BrowseSyncStatus := .F.

#command SET BROWSEFIXEDBLOCKS ON ;
   => ;
      _OOHG_BrowseFixedBlocks := .T.

#command SET BROWSEFIXEDBLOCKS OFF ;
   => ;
      _OOHG_BrowseFixedBlocks := .F.

#command SET BROWSEFIXEDCONTROLS ON ;
   => ;
      _OOHG_BrowseFixedControls := .T.

#command SET BROWSEFIXEDCONTROLS OFF ;
   => ;
      _OOHG_BrowseFixedControls := .F.

#xtranslate BROWSE [ <x> ] DOUBLEBUFFER ;
   => ;
      BROWSE [ <x> ]

#xtranslate BROWSE [ <x> ] IGNORENONE ;
   => ;
      BROWSE [ <x> ]

#xtranslate BROWSE [ <x> ] ENABLEALTA ;
   => ;
      BROWSE [ <x> ]
