/*
 * $Id: i_button.ch,v 1.20 2014-06-06 00:55:42 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Button definitions
 *
 * Copyright 2005-2010 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#xcommand @ <row>,<col> BUTTON <name> ;
            [ OBJ <obj> ] ;
            [ <dummy1: OF, PARENT> <parent> ] ;
            [ <dummy2: ACTION,ON CLICK,ONCLICK> <action> ];
            [ WIDTH <w> ] ;
            [ HEIGHT <h> ] ;
            [ FONT <font> ] ;
            [ SIZE <size> ] ;
            [ <bold : BOLD> ] ;
            [ <italic : ITALIC> ] ;
            [ <underline : UNDERLINE> ] ;
            [ <strikeout : STRIKEOUT> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ <flat: FLAT> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ ON MOUSEMOVE <onmousemove> ] ;
            [ <notabstop: NOTABSTOP> ] ;
            [ HELPID <helpid> ]       ;
            [ <invisible: INVISIBLE> ] ;
            [ <rtl: RTL> ] ;
            [ <noprefix: NOPREFIX> ] ;
            [ SUBCLASS <subclass> ] ;
            [ <disabled: DISABLED> ] ;
            [ CAPTION <caption> ] ;
            [ <dummy3: PICTURE, ICON> <bitmap> ] ;
            [ BUFFER <buffer> ] ;
            [ HBITMAP <hbitmap> ] ;
            [ <notrans: NOLOADTRANSPARENT> ] ;
            [ <scale: FORCESCALE> ] ;
            [ <cancel: CANCEL> ] ;
            [ <alignment:LEFT,RIGHT,TOP,BOTTOM,CENTER> ] ;
            [ <multiline: MULTILINE> ] ;
            [ <themed : THEMED> ] ;
            [ IMAGEMARGIN <aImageMargin> ] ;
            [ <no3dcolors: NO3DCOLORS> ] ;
            [ <autofit: AUTOFIT, ADJUST> ] ;
            [ <lDIB: DIBSECTION> ] ;
   =>;
            [ <obj> := ] _OOHG_SelectSubClass( TButton(), [ <subclass>() ] ): ;
                  Define( <(name)>, <(parent)>, <col>, <row>, <caption>, <{action}>, ;
                  <w>, <h>, <font>, <size>, <tooltip>, <{gotfocus}>,<{lostfocus}>, <.flat.>, <.notabstop.>, ;
                  <helpid>, <.invisible.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>, <.rtl.>, ;
                  <.noprefix.>, <.disabled.>, <buffer>, <hbitmap>, <bitmap>, <.notrans.>, <.scale.>, ;
                  <.cancel.>, <"alignment">, <.multiline.>, <.themed.>, <aImageMargin>, <{onmousemove}>, ;
                  <.no3dcolors.>, <.autofit.>, ! <.lDIB.> )

#command @ <row>,<col> CHECKBUTTON <name> ;
            [ OBJ <obj> ] ;
            [ <dummy1: OF, PARENT> <parent> ] ;
            [ CAPTION <caption> ] ;
            [ WIDTH <w> ] ;
            [ HEIGHT <h> ] ;
            [ VALUE <value> ] ;
            [ FONT <f> ] ;
            [ SIZE <n> ] ;
            [ <bold : BOLD> ] ;
            [ <italic : ITALIC> ] ;
            [ <underline : UNDERLINE> ] ;
            [ <strikeout : STRIKEOUT> ] ;
            [ TOOLTIP <tooltip> ] ;
            [ ON GOTFOCUS <gotfocus> ] ;
            [ ON CHANGE <change> ] ;
            [ ON LOSTFOCUS <lostfocus> ] ;
            [ HELPID <helpid> ]       ;
            [ <invisible: INVISIBLE> ] ;
            [ <notabstop: NOTABSTOP> ] ;
            [ SUBCLASS <subclass> ]           ;
            [ <rtl: RTL> ]                    ;
            [ <dummy3: PICTURE, ICON> <bitmap> ] ;
            [ BUFFER <buffer> ] ;
            [ HBITMAP <hbitmap> ] ;
            [ <notrans: NOLOADTRANSPARENT> ] ;
            [ <scale: FORCESCALE> ] ;
            [ FIELD <field> ] ;
            [ <no3dcolors: NO3DCOLORS> ] ;
            [ <autofit: AUTOFIT, ADJUST> ] ;
            [ <lDIB: DIBSECTION> ] ;
   =>;
            [ <obj> := ] _OOHG_SelectSubClass( TButtonCheck(), [ <subclass>() ] ): ;
                  Define( <(name)>, <(parent)>, <col>, <row>, <caption>, <value>, <f>, <n>, ;
                  <tooltip>, <{change}>, [<w>], [<h>], <{lostfocus}>, <{gotfocus}>, <helpid>, ;
                  <.invisible.>, <.notabstop.>, <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
                  <(field)>, <.rtl.>, <bitmap>, <buffer>, <hbitmap>, <.notrans.>, <.scale.>, ;
                  <.no3dcolors.>, <.autofit.>, ! <.lDIB.> )
