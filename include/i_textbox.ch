/*
 * $Id: i_textbox.ch,v 1.22 2014-04-25 01:48:07 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Textbox definitions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
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

#command @ <row>, <col> TEXTBOX <name> ;
      [ OBJ <obj> ] ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ HEIGHT <height> ] ;
      [ WIDTH <width> ] ;
      [ FIELD <field> ] ;
      [ VALUE <value> ] ;
      [ < readonly: READONLY > ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold : BOLD> ] ;
      [ <italic : ITALIC> ] ;
      [ <underline : UNDERLINE> ] ;
      [ <strikeout : STRIKEOUT> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONTCOLOR <fontcolor> ] ;
      [ MAXLENGTH <maxlength> ] ;
      [ <upper: UPPERCASE> ] ;
      [ <lower: LOWERCASE> ] ;
      [ <password: PASSWORD> ] ;
      [ ON CHANGE <change> ] ;
      [ ON GOTFOCUS <gotfocus> ] ;
      [ ON LOSTFOCUS <lostfocus> ] ;
      [ ON TEXTFILLED <textfilled> ] ;
      [ ON ENTER <enter> ] ;
      [ <RightAlign: RIGHTALIGN> ] ;
      [ <centeralign: CENTERALIGN> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <notabstop: NOTABSTOP> ] ;
      [ <rtl: RTL> ] ;
      [ HELPID <helpid> ] ;
      [ <autoskip: AUTOSKIP> ] ;
      [ <noborder: NOBORDER> ] ;
      [ FOCUSEDPOS <focusedpos> ] ;
      [ <disabled: DISABLED> ] ;
      [ VALID <valid> ] ;
      [ < date : DATE > ] ;
      [ DEFAULTYEAR <year> ] ;
      [ <numeric: NUMERIC> ] ;
      [ <dummy2: INPUTMASK, PICTURE> <inputmask> ] ;
      [ FORMAT <format> ] ;
      [ SUBCLASS <subclass> ] ;
      [ ACTION <action> ] ;
      [ ACTION2 <action2> ] ;
      [ IMAGE <abitmap> ] ;
      [ BUTTONWIDTH <btnwidth> ] ;
      [ WHEN <bWhen> ] ;
      [ INSERTTYPE <nInsType> ] ;
   => ;
      [ <obj> := ] DefineTextBox( <(name)>, <(parent)>, <col>, <row>, <width>, <height>, ;
            <value>, <fontname>, <fontsize>, <tooltip>, <maxlength>, ;
            <.upper.>, <.lower.>, <.password.>, ;
            <{lostfocus}>, <{gotfocus}>, <{change}>, <{enter}>, ;
            <.RightAlign.>, <helpid>, <.readonly.>, <.bold.>, ;
            <.italic.>, <.underline.>, <.strikeout.>, <(field)>, ;
            <backcolor>, <fontcolor>, <.invisible.>, <.notabstop.>, ;
            <.rtl.>, <.autoskip.>, <.noborder.>, <focusedpos>, <.disabled.>, ;
            <{valid}>, <.date.>, <.numeric.>, <inputmask>, <format>, ;
            [ <subclass>() ], <{action}>, <abitmap>, <btnwidth>, <{action2}>, ;
            <{bWhen}>, <.centeralign.>, <year>, <{textfilled}>, <nInsType> )
