/*
 * $Id: i_image.ch $
 */
/*
 * OOHG source code:
 * Image definitions
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


#command @ <row>, <col> IMAGE <name> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ <dummy: ACTION, ON CLICK, ONCLICK> <action> ] ;
      [ WIDTH <width> ] ;
      [ HEIGHT <height> ] ;
      [ <stretch: STRETCH> ] ;
      [ HELPID <helpid> ] ;
      [ <invisible: INVISIBLE> ] ;
      [ <rtl: RTL> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <whitebackground: WHITEBACKGROUND> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ PICTURE <filename> ] ;
      [ BUFFER <buffer> ] ;
      [ HBITMAP <hbitmap> ] ;
      [ <noresize: NORESIZE> ] ;
      [ <imagesize: IMAGESIZE> ] ;
      [ TOOLTIP <tooltip> ] ;
      [ <border: BORDER> ] ;
      [ <clientedge: CLIENTEDGE> ] ;
      [ <notrans: NOLOADTRANSPARENT> ] ;
      [ <no3dcolors: NO3DCOLORS> ] ;
      [ <nodib: NODIBSECTION> ] ;
      [ <style: TRANSPARENT> ] ;
      [ EXCLUDEAREA <area> [ OF <coord: CONTROL, FORM> ] ] ;
      [ <disabled: DISABLED> ] ;
      [ <dummy: ONCHANGE, ON CHANGE> <change> ] ;
      [ <dummy: ONRCLICK, ON RCLICK> <rclk> ] ;
      [ <dummy: ONMCLICK, ON MCLICK> <mclk> ] ;
      [ <dummy: ONDBLCLICK, ON DBLCLICK> <dblclk> ] ;
      [ <dummy: ONRDBLCLICK, ON RDBLCLICK> <rdblclk> ] ;
      [ <dummy: ONMDBLCLICK, ON MDBLCLICK> <mdblclk> ] ;
      [ <nocheck: NOCHECKDEPTH> ] ;
      [ <noredraw: NOPARENTREDRAW> ] ;
      [ <dummy: ONMOUSEMOVE, ON MOUSEMOVE, ONMOUSEHOVER, ON MOUSEHOVER> <onmousemove> ] ;
      [ <dummy: ON MOUSELEAVE, ONMOUSELEAVE> <onmouseleave> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TImage(), [ <subclass>() ] ):Define( ;
            <(name)>, <(parent)>, <col>, <row>, <filename>, <width>, <height>, ;
            <{action}>, <helpid>, <.invisible.>, <.stretch.>, ;
            <.whitebackground.>, <.rtl.>, <backcolor>, <buffer>, <hbitmap>, ;
            ! <.noresize.>, <.imagesize.>, <tooltip>, <.border.>, ;
            <.clientedge.>, <.notrans.>, <.no3dcolors.>, <.nodib.>, <.style.>, ;
            <area>, <.disabled.>, <{change}>, <{dblclk}>, <{mclk}>, <{mdblclk}>, ;
            <{rclk}>, <{rdblclk}>, <.nocheck.>, <.noredraw.>, <{onmousemove}> ;
            <{onmouseleave}>, <"coord"> )
