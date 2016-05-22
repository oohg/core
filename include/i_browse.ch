/*
 * $Id: i_browse.ch,v 1.63 2016-05-22 23:52:22 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Browse definitions
 *
 * Copyright 2007-2016 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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
      [ <dummy06: ACTION, ONCLICK, ON CLICK> <click> ] ;
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
      [ <nomodal: NOMODALEDIT> ] ;
      [ <bycell: NAVIGATEBYCELL> ] ;
      [ <extdbl: EXTDBLCLICK> ] ;
      [ <silent: SILENT> ] ;
      [ <alta: ENABLEALTA, DISABLEALTA> ] ;
      [ <noshow: NOSHOWALWAYS> ] ;
      [ <none: NONEUNSELS, IGNORENONE> ] ;
      [ <cbe: CHANGEBEFOREEDIT> ] ;
      [ <dummy15: ONRCLICK, ON RCLICK> <rclick> ] ;
      [ <checkboxes: CHECKBOXES> ] ;
      [ <dummy16: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
      [ <dummy17: ONROWREFRESH, ON ROWREFRESH> <rowrefresh> ] ;
      [ DEFAULTVALUES <aDefVal> ] ;
      [ <dummy18: ONEDITCELLEND, ON EDITCELLEND> <editend> ] ;
      [ <efv: EDITFIRSTVISIBLE> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( IIF( <.bycell.>, TOBrowseByCell(), TOBrowse() ), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, ;
            <{change}>, <{dblclick}>, <aHeadClick>, <{gotfocus}>, ;
            <{lostfocus}>, <(workarea)>, <.delete.>, <.style.>, <aImage>, ;
            <aJust>, <helpid>, <.bold.>, <.italic.>, <.underline.>, ;
            <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, <.lock.>, ;
            <.inplace.>, <.novscroll.>, <.append.>, <aReadOnly>, ;
            <aValidFields>, <aValidMessages>, <.edit.>, <dynamicbackcolor>, ;
            <aWhenFields>, <dynamicforecolor>, <Picture>, <.rtl.>, ;
            <{onappend}>, <{editcell}>, <editcontrols>, <replacefields>, ;
            <.reccount.>, <columninfo>, ! <.noshowheaders.>, <{enter}>, ;
            <.disabled.>, <.notabstop.>, <.invisible.>, <.descending.>, ;
            <{bWhenDel}>, <DelMsg>, <{onDelete}>, <aHeaderImages>, ;
            <aImgAlign>, <.fullmove.>, <aSelectedColors>, <aEditKeys>, ;
            IIF( <.forcerefresh.>, 0, IIF( <.norefresh.>, 1, NIL ) ), ;
            IIF( Upper( #<bffr> ) == "DOUBLEBUFFER", .T., ;
            IIF( Upper( #<bffr> ) == "SINGLEBUFFER", .F., .T. ) ), ;
            IIF( Upper( #<focus> ) == "NOFOCUSRECT", .F., ;
            IIF( Upper( #<focus> ) == "FOCUSRECT", .T., NIL ) ), ;
            <.plm.>, IIF( Upper( #<sync> ) == "UNSYNCHRONIZED", .F., ;
            IIF( Upper( #<sync> ) == "SYNCHRONIZED", .T., NIL ) ), ;
            <.fixedcols.>, <.nodelmsg.>, <.updall.>, <{abortedit}>, <{click}>, ;
            <.fixedwidths.>, IIF( Upper( #<blocks> ) == "FIXEDBLOCKS", .T., ;
            IIF( Upper( #<blocks> ) == "DYNAMICBLOCKS", .F., NIL ) ), ;
            <{bBefMov}>, <{bAftMov}>, <{bBefSiz}>, <{bAftSiz}>, <{bBefAut}>, ;
            <.excel.>, <.buts.>, <.upcol.>, ;
            IIF( Upper( #<edtctrls> ) == "FIXEDCONTROLS", .T., ;
            IIF( Upper( #<edtctrls> ) == "DYNAMICCONTROLS", .F., NIL ) ), ;
            <{bheadrclick}>, <.extdbl.>, <.nomodal.>, <.silent.>, ;
            ! Upper( #<alta> ) == "DISABLEALTA", <.noshow.>, ;
            Upper( #<none> ) == "NONEUNSELS", <.cbe.>, <{rclick}>, ;
            <.checkboxes.>, <{checkchange}>, <{rowrefresh}>, <aDefVal>, ;
            <{editend}>, ! <.efv.> )

#command SET BROWSESYNC ON ;
   => ;
      SetBrowseSync( .T. )

#command SET BROWSESYNC OFF ;
   => ;
      SetBrowseSync( .F. )

#command SET BROWSEFIXEDBLOCKS ON ;
   => ;
      SetBrowseFixedBlocks( .T. )

#command SET BROWSEFIXEDBLOCKS OFF ;
   => ;
      SetBrowseFixedBlocks( .F. )

#command SET BROWSEFIXEDCONTROLS ON ;
   => ;
      SetBrowseFixedControls( .T. )

#command SET BROWSEFIXEDCONTROLS OFF ;
   => ;
      SetBrowseFixedControls( .F. )
