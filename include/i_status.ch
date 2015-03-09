/*
 * $Id: i_status.ch,v 1.11 2015-03-09 02:51:07 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Statusbar definitions
 *
 * Copyright 2007-2015 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2015, http://www.harbour-project.org/
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

#xcommand DEFINE STATUSBAR ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ OBJ <obj> ] ;
      [ <kbd: KEYBOARD> ] ;
      [ <date: DATE> ] ;
      [ <clock: CLOCK> ] ;
      [ FONT <fontname> ] ;
      [ SIZE <fontsize> ] ;
      [ <bold: BOLD> ] ;
      [ <top: TOP> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ MESSAGE <msg> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <noautoadjust: NOAUTOADJUST> ] ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl: FLAT, RAISED> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <align: LEFT, CENTER, RIGHT> ] ;
   => ;
      [ <obj> := ] _OOHG_SelectSubClass( TMessageBar(), [ <subclass>() ] ): ;
            Define( "StatusBar", <(parent)>, 0, 0, 0, 0, <msg>, <{uAction}>, ;
            <fontname>, <fontsize>, <cToolTip>, <.clock.>, <.date.>, <.kbd.>, ;
            NIL, NIL, <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
            <.top.>, <.noautoadjust.>, <nSize>, <cBitmap>, <(styl)>, <(align)> )

#xcommand END STATUSBAR ;
   => ;
      _EndMessageBar ()

#xcommand STATUSITEM [ <cMsg> ] ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;
   => ;
      _SetStatusItem( <cMsg>, <nSize>, <{uAction}>, <cToolTip>, <cBitmap>, ;
            <(styl)>, <(align)> )

#xcommand DATE ;
      [ <w: WIDTH > <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;
   => ;
      _SetStatusItem( Dtoc( Date() ), ;
            IIF( <.w.>, <nSize>, ;
            IIF( "yyyy" $ Lower( Set( _SET_DATEFORMAT ) ), 95, 75 ) ), ;
            <{uAction}>, <cToolTip>, NIL, <(styl)>, <(align)> )

#xcommand CLOCK ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <ampm: AMPM> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl: FLAT, RAISED> ] ;
      [ <align: LEFT, CENTER, RIGHT> ] ;
   => ;
      _SetStatusClock( <nSize>, <cToolTip>, <{uAction}>, <.ampm.>, <cBitmap>, ;
            <(styl)>, <(align)> )

#xcommand KEYBOARD ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl: FLAT, RAISED> ] ;
      [ <align: LEFT, CENTER, RIGHT> ] ;
   => ;
      _SetStatusKeybrd( <nSize>, <cToolTip>, <{uAction}>, <cBitmap>, ;
            <(styl)>, <(align)> )
