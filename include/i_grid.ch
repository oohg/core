/*
 * $Id: i_grid.ch $
 */
/*
 * ooHG source code:
 * Grid definitions
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


#define GRID_JTFY_LEFT      0
#define GRID_JTFY_RIGHT     1
#define GRID_JTFY_CENTER    2

#define HEADER_IMG_AT_LEFT  0
#define HEADER_IMG_AT_RIGHT 1

/*---------------------------------------------------------------------------
STANDARD VERSION
---------------------------------------------------------------------------*/

#command @ <row>, <col> GRID <name> ;
      [ OBJ <obj> ] ;
      [ <dummy01: OF, PARENT> <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ INPUTMASK <inputmask> ] ;
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
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy05: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ <dummy06: ACTION, ONCLICK, ON CLICK> <click> ] ;
      [ <dummy07: ONHEADCLICK, ON HEADCLICK> <aHeadClick> ] ;
      [ <edit: EDIT> ] ;
      [ <ownerdata: VIRTUAL> ] ;
      [ ITEMCOUNT <itemcount> ] ;
      [ <dummy08: ONQUERYDATA, ON QUERYDATA> <dispinfo> ] ;
      [ <multiselect: MULTISELECT> ] ;
      [ <style: NOLINES> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ <rtl: RTL> ] ;
      [ <inplace: INPLACE> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ READONLY <aReadOnly> ] ;
      [ <dummy20: VALID, COLUMNVALID> <aValidFields> ] ;
      [ VALIDMESSAGES <aValidMessages> ] ;
      [ <dummy09: ONEDITCELL, ON EDITCELL> <editcell> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ <dummy10: WHEN, COLUMNWHEN> <aWhenFields> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <disabled: DISABLED> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ HEADERIMAGES <aHeaderImages> ] ;
      [ <dummy21: HEADERIMAGESALIGN, IMAGESALIGN> <aImgAlign> ] ;
      [ <fullmove: FULLMOVE> ] ;
      [ <bycell: NAVIGATEBYCELL> ] ;
      [ SELECTEDCOLORS <aSelectedColors> ] ;
      [ EDITKEYS <aEditKeys> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <dummy12: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
      [ <bffr: SINGLEBUFFER> ] ;
      [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
      [ <plm: PAINTLEFTMARGIN> ] ;
      [ <fixedcols: FIXEDCOLS> ] ;
      [ <dummy13: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
      [ <fixedwidths: FIXEDWIDTHS> ] ;
      [ BEFORECOLMOVE <bBefMov> ] ;
      [ AFTERCOLMOVE <bAftMov> ] ;
      [ BEFORECOLSIZE <bBefSiz> ] ;
      [ AFTERCOLSIZE <bAftSiz> ] ;
      [ BEFOREAUTOFIT <bBefAut> ] ;
      [ <excel: EDITLIKEEXCEL> ] ;
      [ <buts: USEBUTTONS> ] ;
      [ <delete: DELETE> ] ;
      [ DELETEWHEN <bWhenDel> ] ;
      [ DELETEMSG <DelMsg> ] ;
      [ <dummy14: ONDELETE, ON DELETE> <onDelete> ] ;
      [ <nodelmsg: NODELETEMSG> ] ;
      [ <append: APPEND> ] ;
      [ <dummy15: ONAPPEND, ON APPEND> <onappend> ] ;
      [ <nomodal: NOMODALEDIT> ] ;
      [ <edtctrls: FIXEDCONTROLS, DYNAMICCONTROLS> ] ;
      [ <dummy16: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
      [ <noclick: NOCLICKONCHECKBOX> ] ;
      [ <norclick: NORCLICKONCHECKBOX> ] ;
      [ <extdbl: EXTDBLCLICK> ] ;
      [ <silent: SILENT> ] ;
      [ <alta: ENABLEALTA> ] ;
      [ <noshow: NOSHOWALWAYS> ] ;
      [ <none: NONEUNSELS> ] ;
      [ <cbe: CHANGEBEFOREEDIT> ] ;
      [ <dummy17: ONRCLICK, ON RCLICK> <rclick> ] ;
      [ <dummy18: ONINSERT, ON INSERT> <oninsert> ] ;
      [ <dummy19: ONEDITCELLEND, ON EDITCELLEND> <editend> ] ;
      [ <efv: EDITFIRSTVISIBLE> ] ;
      [ <dummy20: ONBEFOREEDITCELL, ON BEFOREEDITCELL> <beforedit> ] ;
      [ EDITCELLVALUE <edtval> ] ;
      [ <klc: KEYSLIKECLIPPER> ] ;
      [ <ctt: CELLTOOLTIP> ] ;
      [ <nohsb: NOHSCROLL, NOHSCROLLBAR> ] ;
      [ <novsb: NOVSCROLL, NOVSCROLLBAR> ] ;
      [ <dummy21: ONBEFOREINSERT, ON BEFOREINSERT> <beforeins> ] ;
      [ <dummy22: ONHEADDBLCLICK, ON HEADDBLCLICK> <aHeadDblClick> ] ;
      [ HEADERCOLORS <aHeadClr> ] ;
      [ TIMEOUT <nTime> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( iif( <.bycell.>, TGridByCell(), ;
            iif( <.multiselect.>, TGridMulti(), TGrid() ) ), ;
            [ <subclass>() ] ):Define( <(name)>, <(parent)>, <col>, <row>, ;
            <w>, <h>, <headers>, <widths>, <rows>, <value>, <fontname>, ;
            <fontsize>, <tooltip>, <{change}>, <{dblclick}>, <aHeadClick>, ;
            <{gotfocus}>, <{lostfocus}>, <.style.>, <aImage>, <aJust>, ;
            <.break.>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.ownerdata.>, <{dispinfo}>, <itemcount>, <.edit.>, ;
            <backcolor>, <fontcolor>, <dynamicbackcolor>, <dynamicforecolor>, ;
            <inputmask>, <.rtl.>, <.inplace.>, <editcontrols>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <{editcell}>, <aWhenFields>, ;
            <.disabled.>, <.notabstop.>, <.invisible.>, ! <.noshowheaders.>, ;
            <{enter}>, <aHeaderImages>, <aImgAlign>, <.fullmove.>, ;
            <aSelectedColors>, <aEditKeys>, <.checkboxes.>, <{checkchange}>, ;
            ! <.bffr.>, ;
            iif( #<focus> == "NOFOCUSRECT", .F., ;
            iif( #<focus> == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, <.fixedcols.>, <{abortedit}>, <{click}>, <.fixedwidths.>, ;
            <{bBefMov}>, <{bAftMov}>, <{bBefSiz}>, <{bAftSiz}>, <{bBefAut}>, ;
            <.excel.>, <.buts.>, <.delete.>, <{onDelete}>, <{bWhenDel}>, ;
            <DelMsg>, <.nodelmsg.>, <.append.>, <{onappend}>, <.nomodal.>, ;
            iif( Upper( #<edtctrls> ) == "FIXEDCONTROLS", .T., ;
            iif( Upper( #<edtctrls> ) == "DYNAMICCONTROLS", .F., NIL ) ), ;
            <{bheadrclick}>, ! <.noclick.>, ! <.norclick.>, <.extdbl.>, ;
            <.silent.>, <.alta.>, <.noshow.>, <.none.>, <.cbe.>, <{rclick}>, ;
            <{oninsert}>, <{editend}>, ! <.efv.>, <{beforedit}>, <{edtval}>, ;
            <.klc.>, <.ctt.>, <.nohsb.>, <.novsb.>, <{beforeins}>, ;
            <aHeadDblClick>, <aHeadClr>, <nTime> )

/*---------------------------------------------------------------------------
SPLITBOX VERSION
---------------------------------------------------------------------------*/

#command GRID <name> ;
      [ OBJ <obj> ] ;
      [ <dummy01: OF, PARENT> <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ HEADERS <headers> ] ;
      [ WIDTHS <widths> ] ;
      [ INPUTMASK <inputmask> ] ;
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
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy05: ONDBLCLICK, ON DBLCLICK> <dblclick> ] ;
      [ <dummy06: ACTION, ONCLICK, ON CLICK> <click> ] ;
      [ <dummy07: ONHEADCLICK, ON HEADCLICK> <aHeadClick> ] ;
      [ <edit: EDIT> ] ;
      [ <ownerdata: VIRTUAL> ] ;
      [ ITEMCOUNT <itemcount> ] ;
      [ <dummy08: ONQUERYDATA, ON QUERYDATA> <dispinfo> ] ;
      [ <multiselect: MULTISELECT> ] ;
      [ <style: NOLINES> ] ;
      [ IMAGE <aImage> ] ;
      [ JUSTIFY <aJust> ] ;
      [ HELPID <helpid> ] ;
      [ <break: BREAK> ] ;
      [ <rtl: RTL> ] ;
      [ <inplace: INPLACE> ] ;
      [ COLUMNCONTROLS <editcontrols> ] ;
      [ READONLY <aReadOnly> ] ;
      [ <dummy20: VALID, COLUMNVALID> <aValidFields> ] ;
      [ VALIDMESSAGES <aValidMessages> ] ;
      [ <dummy09: ONEDITCELL, ON EDITCELL> <editcell> ] ;
      [ <noshowheaders: NOHEADERS> ] ;
      [ <dummy10: WHEN, COLUMNWHEN> <aWhenFields> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <disabled: DISABLED> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ HEADERIMAGES <aHeaderImages> ] ;
      [ <dummy21: HEADERIMAGESALIGN, IMAGESALIGN> <aImgAlign> ] ;
      [ <fullmove: FULLMOVE> ] ;
      [ <bycell: NAVIGATEBYCELL> ] ;
      [ SELECTEDCOLORS <aSelectedColors> ] ;
      [ EDITKEYS <aEditKeys> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <dummy12: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
      [ <bffr: SINGLEBUFFER> ] ;
      [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
      [ <plm: PAINTLEFTMARGIN> ] ;
      [ <fixedcols: FIXEDCOLS> ] ;
      [ <dummy13: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
      [ <fixedwidths: FIXEDWIDTHS> ] ;
      [ BEFORECOLMOVE <bBefMov> ] ;
      [ AFTERCOLMOVE <bAftMov> ] ;
      [ BEFORECOLSIZE <bBefSiz> ] ;
      [ AFTERCOLSIZE <bAftSiz> ] ;
      [ BEFOREAUTOFIT <bBefAut> ] ;
      [ <excel: EDITLIKEEXCEL> ] ;
      [ <buts: USEBUTTONS> ] ;
      [ <delete: DELETE> ] ;
      [ DELETEWHEN <bWhenDel> ] ;
      [ DELETEMSG <DelMsg> ] ;
      [ <dummy14: ONDELETE, ON DELETE> <onDelete> ] ;
      [ <nodelmsg: NODELETEMSG> ] ;
      [ <append: APPEND> ] ;
      [ <dummy15: ONAPPEND, ON APPEND> <onappend> ] ;
      [ <nomodal: NOMODALEDIT> ] ;
      [ <edtctrls: FIXEDCONTROLS, DYNAMICCONTROLS> ] ;
      [ <dummy16: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
      [ <noclick: NOCLICKONCHECKBOX> ] ;
      [ <norclick: NORCLICKONCHECKBOX> ] ;
      [ <extdbl: EXTDBLCLICK> ] ;
      [ <silent: SILENT> ] ;
      [ <alta: ENABLEALTA> ] ;
      [ <noshow: NOSHOWALWAYS> ] ;
      [ <none: NONEUNSELS> ] ;
      [ <cbe: CHANGEBEFOREEDIT> ] ;
      [ <dummy17: ONRCLICK, ON RCLICK> <rclick> ] ;
      [ <dummy18: ONINSERT, ON INSERT> <oninsert> ] ;
      [ <dummy19: ONEDITCELLEND, ON EDITCELLEND> <editend> ] ;
      [ <efv: EDITFIRSTVISIBLE> ] ;
      [ <dummy20: ONBEFOREEDITCELL, ON BEFOREEDITCELL> <beforedit> ] ;
      [ EDITCELLVALUE <edtval> ] ;
      [ <klc: KEYSLIKECLIPPER> ] ;
      [ <ctt: CELLTOOLTIP> ] ;
      [ <nohsb: NOHSCROLLBAR> ] ;
      [ <novsb: NOVSCROLLBAR> ] ;
      [ <dummy21: ONBEFOREINSERT, ON BEFOREINSERT> <beforeins> ] ;
      [ <dummy22: ONHEADDBLCLICK, ON HEADDBLCLICK> <aHeadDblClick> ] ;
      [ HEADERCOLORS <aHeadClrs> ] ;
      [ TIMEOUT <nTime> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( iif( <.bycell.>, TGridByCell(), ;
            iif( <.multiselect.>, TGridMulti(), TGrid() ) ), ;
            [ <subclass>() ] ):Define( <(name)>, <(parent)>, , , <w>, <h>, ;
            <headers>, <widths>, <rows>, <value>, <fontname>, <fontsize>, ;
            <tooltip>, <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <.style.>, <aImage>, <aJust>, <.break.>, <helpid>, ;
            <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, <.ownerdata.>, ;
            <{dispinfo}>, <itemcount>, <.edit.>, <backcolor>, <fontcolor>, ;
            <dynamicbackcolor>, <dynamicforecolor>, <inputmask>, <.rtl.>, ;
            <.inplace.>, <editcontrols>, <aReadOnly>, <aValidFields>, ;
            <aValidMessages>, <{editcell}>, <aWhenFields>, <.disabled.>, ;
            <.notabstop.>, <.invisible.>, ! <.noshowheaders.>, <{enter}>, ;
            <aHeaderImages>, <aImgAlign>, <.fullmove.>, <aSelectedColors>, ;
            <aEditKeys>, <.checkboxes.>, <{checkchange}>, ;
            ! <.bffr.>, ;
            iif( #<focus> == "NOFOCUSRECT", .F., ;
            iif( #<focus> == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, <.fixedcols.>, <{abortedit}>, <{click}>, <.fixedwidths.>, ;
            <{bBefMov}>, <{bAftMov}>, <{bBefSiz}>, <{bAftSiz}>, <{bBefAut}>, ;
            <.excel.>, <.buts.>, <.delete.>, <{onDelete}>, <{bWhenDel}>, ;
            <DelMsg>, <.nodelmsg.>, <.append.>, <{onappend}>, <.nomodal.>, ;
            iif( Upper( #<edtctrls> ) == "FIXEDCONTROLS", .T., ;
            iif( Upper( #<edtctrls> ) == "DYNAMICCONTROLS", .F., NIL ) ), ;
            <{bheadrclick}>, ! <.noclick.>, ! <.norclick.>, <.extdbl.>, ;
            <.silent.>, <.alta.>, <.noshow.>, <.none.>, <.cbe.>, <{rclick}>, ;
            <{oninsert}>, <{editend}>, ! <.efv.>, <{beforedit}>, <{edtval}>, ;
            <.klc.>, <.ctt.>, <.nohsb.>, <.novsb.>, <{beforeins}>, ;
            <aHeadDblClick>, <aHeadClrs>, <nTime> )

#command SET GRIDFIXEDCONTROLS ON ;
   => ;
      _OOHG_GridFixedControls := .T.

#command SET GRIDFIXEDCONTROLS OFF ;
   => ;
      _OOHG_GridFixedControls := .F.

#xtranslate GRID [ <x> ] DOUBLEBUFFER ;
   => ;
      GRID [ <x> ]

#xtranslate GRID [ <x> ] IGNORENONE ;
   => ;
      GRID [ <x> ]

#xtranslate GRID [ <x> ] DISABLEALTA ;
   => ;
      GRID [ <x> ]
