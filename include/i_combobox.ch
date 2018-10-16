/*
 * $Id: i_combobox.ch $
 */
/*
 * ooHG source code:
 * Combobox definitions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


/*---------------------------------------------------------------------------
STANDARD VERSION
---------------------------------------------------------------------------*/

#xcommand @ <row>, <col> COMBOBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ ITEMS <rows> ] ;
      [ ITEMSOURCE <itemsource> ] ;
      [ ITEMIMAGENUMBER <itemimagenumber> ] ;
      [ VALUE <value> ] ;
      [ VALUESOURCE <valuesource> ] ;
      [ <displayedit: DISPLAYEDIT> [ MAXLENGTH <max> ] ] ;
      [ FONT <f> ] ;
      [ SIZE <n> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ <dummy03: ONCHANGE, ON CHANGE> <changeprocedure> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ ON DISPLAYCHANGE <displaychng> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ IMAGE <aImage> ] ;
      [ IMAGESOURCE <imagesource> ] ;
      [ <fit: FIT> ] ;
      [ <sort: SORT> ] ;
      [ <rtl: RTL> ] ;
      [ TEXTHEIGHT <textheight> ] ;
      [ EDITHEIGHT <editheight> ] ;
      [ OPTIONSHEIGHT <optheight> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <disabled: DISABLED> ] ;
      [ <firstitem: FIRSTITEM> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ LISTWIDTH <listwidth> ] ;
      [ ON LISTDISPLAY <listdisplay> ] ;
      [ ON LISTCLOSE <listclose> ] ;
      [ <delay: DELAYEDLOAD> ] ;
      [ <incremental: INCREMENTAL> ] ;
      [ <winsize: INTEGRALHEIGHT> ] ;
      [ <rfrsh: REFRESH, NOREFRESH> ] ;
      [ SOURCEORDER <sourceorder> ] ;
      [ ON REFRESH <refresh> ] ;
      [ SEARCHLAPSE <nLapse> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TCombo(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, <col>, <row>, <w>, <rows>, <value>, ;
            <f>, <n>, <tooltip>, <{changeprocedure}>, <h>,  <{gotfocus}>, ;
            <{lostfocus}>, <{enter}>, <helpid>, <.invisible.>, <.notabstop.>, ;
            <.sort.>,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
            <(itemsource)>, <(valuesource)>, <.displayedit.>, ;
            <{displaychng}>, .F., "", <aImage>, <.rtl.>, <textheight>, ;
            <.disabled.>, <.firstitem.>, <.fit.>, <backcolor>, <fontcolor>, ;
            <listwidth>, <{listdisplay}>, <{listclose}>, <{imagesource}>, ;
            <{itemimagenumber}>, <.delay.>, <.incremental.>, <.winsize.>, ;
            IIF( Upper( #<rfrsh> ) == "NOREFRESH", .F., ;
            IIF( Upper( #<rfrsh> ) == "REFRESH", .T., NIL ) ), ;
            <(sourceorder)>, <{refresh}>, <nLapse>, <max>, <editheight>, ;
            <optheight> )

/*---------------------------------------------------------------------------
SPLITBOX VERSION
---------------------------------------------------------------------------*/

#xcommand COMBOBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ ITEMS <rows> ] ;
      [ ITEMSOURCE <itemsource> ] ;
      [ ITEMIMAGENUMBER <itemimagenumber> ] ;
      [ VALUE <value> ] ;
      [ VALUESOURCE <valuesource> ] ;
      [ <displayedit: DISPLAYEDIT> [ MAXLENGTH <max> ] ] ;
      [ FONT <f> ] ;
      [ SIZE <n> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <gotfocus> ] ;
      [ ON CHANGE <changeprocedure> ] ;
      [ <dummy04: ONLOSTFOCUS, ON LOSTFOCUS> <lostfocus> ] ;
      [ <dummy11: ONENTER, ON ENTER> <enter> ] ;
      [ ON DISPLAYCHANGE <displaychng> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ HELPID <helpid> ] ;
      [ GRIPPERTEXT <grippertext> ] ;
      [ <break: BREAK> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ IMAGE <aImage> ] ;
      [ IMAGESOURCE <imagesource> ] ;
      [ <fit: FIT> ] ;
      [ <sort: SORT> ] ;
      [ <rtl: RTL> ] ;
      [ TEXTHEIGHT <textheight> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <disabled: DISABLED> ] ;
      [ <firstitem: FIRSTITEM> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ LISTWIDTH <listwidth> ] ;
      [ ON LISTDISPLAY <listdisplay> ] ;
      [ ON LISTCLOSE <listclose> ] ;
      [ <delay: DELAYEDLOAD> ] ;
      [ <incremental: INCREMENTAL> ] ;
      [ <winsize: INTEGRALHEIGHT> ] ;
      [ <rfrsh: REFRESH, NOREFRESH> ] ;
      [ SOURCEORDER <sourceorder> ] ;
      [ ON REFRESH <refresh> ] ;
      [ SEARCHLAPSE <nLapse> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TCombo(), [ <subclass>() ] ): ;
            Define( <(name)>, <(parent)>, , , <w>, <rows>, <value>, ;
            <f>, <n>, <tooltip>, <{changeprocedure}>, <h>, <{gotfocus}>, ;
            <{lostfocus}>, <{enter}>, <helpid>, <.invisible.>, <.notabstop.>, ;
            <.sort.>,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
            <(itemsource)>, <(valuesource)>, <.displayedit.>, <{displaychng}>, ;
            <.break.>, <grippertext>, <aImage>, <.rtl.>, <textheight>, ;
            <.disabled.>, <.firstitem.>, <.fit.>, <backcolor>, <fontcolor>, ;
            <listwidth>, <{listdisplay}>, <{listclose}>, <{imagesource}>, ;
            <{itemimagenumber}>, <.delay.>, <.incremental.>, <.winsize.>, ;
            IIF( Upper( #<rfrsh> ) == "NOREFRESH", .F., ;
            IIF( Upper( #<rfrsh> ) == "REFRESH", .T., NIL ) ), ;
            <(sourceorder)>, <{refresh}>, <nLapse>, <max> )

#command SET COMBOREFRESH ON ;
   => ;
      SetComboRefresh( .T. )

#command SET COMBOREFRESH OFF ;
   => ;
      SetComboRefresh( .F. )
