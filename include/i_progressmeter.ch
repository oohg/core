/*
 * $Id: i_progressmeter.ch,v 1.1 2005-09-04 00:19:13 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Progress meter definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#command @ <row>,<col> PROGRESSMETER <name>       ;
                [ OBJ <obj> ]                     ;
		[ <dummy1: OF, PARENT> <parent> ] ;
                [ RANGE <lo> , <hi> ]             ;
                [ VALUE <v> ]                     ;
                [ WIDTH <w> ]                     ;
                [ HEIGHT <h> ]                    ;
                [ TOOLTIP <tooltip> ]             ;
                [ HELPID <helpid> ]               ;
                [ <invisible : INVISIBLE> ]       ;
                [ BACKCOLOR <backcolor> ]         ;
                [ FORECOLOR <forecolor> ]         ;
                [ FONT <fontname> ]               ;
                [ SIZE <fontsize> ]               ;
                [ <bold : BOLD> ]                 ;
                [ <italic : ITALIC> ]             ;
                [ <underline : UNDERLINE> ]       ;
                [ <strikeout : STRIKEOUT> ]       ;
                [ ACTION <action> ]               ;
                [ <rtl: RTL> ]                    ;
	=>;
        [ <obj> := ] TProgressMeter():Define( <"name">, <"parent">, <col>, <row>, <w>, <h>, ;
                <lo>, <hi>, <v>, <tooltip>, <fontname>, <fontsize>, <.bold.>, <.italic.>, ;
                <.underline.>, <.strikeout.>, <forecolor>, <backcolor>, <{action}>, <.rtl.> )