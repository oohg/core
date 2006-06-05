/*
 * $Id: i_tab.ch,v 1.5 2006-06-05 00:53:41 guerra000 Exp $
 */
/*
 * ooHG source code:
 * TAB control definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
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

#command DEFINE TAB <name> ;
                [ OBJ <obj> ] ;
		[ <dummy1: OF, PARENT> <parent> ] ;
		AT <row> , <col> ;
		WIDTH <w> ;
		HEIGHT <h> ;
		[ VALUE <value> ] ;
		[ FONT <f> ] ;
		[ SIZE <s> ] ;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ] ;
                [ <buttons: BUTTONS> ]       ;
                [ <flat: FLAT> ]       ;
                [ <hottrack: HOTTRACK> ]       ;
                [ <vertical: VERTICAL> ]       ;
		[ ON CHANGE <change> ] ;
                [ <notabstop: NOTABSTOP> ]       ;
                [ <rtl: RTL> ]       ;
                [ SUBCLASS <subclass> ] ;
                [ <internals: INTERNALS> ]       ;
	=>;
             [ <obj> := ] _OOHG_SelectSubClass( TTab(), [ <subclass>() ] ): ;
             Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, {}, {}, <value>, <f>, <s>, <tooltip>, ;
                     <{change}>, <.buttons.>, <.flat.>, <.hottrack.>, <.vertical.>, <.notabstop.>, , ;
                     <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, {}, <.rtl.>, <.internals.> )

#command PAGE <caption> [ IMAGE <image> ] [ NAME <name> ] [ OBJ <obj> ] [ SUBCLASS <subclass> ] ;
	=>;
        [ <obj> := ] ;
        _BeginTabPage( <caption>, <image>,, <(name)>, [ <subclass>() ] )

#command DEFINE PAGE <caption> [ IMAGE <image> ] [ NAME <name> ] [ OBJ <obj> ] [ SUBCLASS <subclass> ] ;
	=>;
        [ <obj> := ] ;
        _BeginTabPage( <caption>, <image>,, <(name)>, [ <subclass>() ] )

#command DEFINE TAB PAGE <caption> [ IMAGE <image> ] [ NAME <name> ] [ OBJ <obj> ] [ SUBCLASS <subclass> ] ;
	=>;
        [ <obj> := ] ;
        _BeginTabPage( <caption>, <image>,, <(name)>, [ <subclass>() ] )

#command END PAGE ;
	=>;
	_EndTabPage()

#command END TAB ;
	=>;
	_EndTab()
