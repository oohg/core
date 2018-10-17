/*
 * $Id: i_app.ch $
 */
/*
 * ooHG source code:
 * Application object definitions
 *
 * Copyright 2015-2018 Fernando Yurisich <fyurisich@oohg.org>
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


#xtranslate <p:Application,App>.ArgC                       => TApplication():Define():ArgC
#xtranslate <p:Application,App>.Args                       => TApplication():Define():Args
#xtranslate <p:Application,App>.BackColor := <arg>         => TApplication():Define():BackColor( <arg> )
#xtranslate <p:Application,App>.BackColor                  => TApplication():Define():BackColor()
#xtranslate <p:Application,App>.Cargo := <arg>             => TApplication():Define():Cargo( <arg> )
#xtranslate <p:Application,App>.Cargo                      => TApplication():Define():Cargo()
#xtranslate <p:Application,App>.ClientHeight := <arg>      => TApplication():Define():ClientHeight( <arg> )
#xtranslate <p:Application,App>.ClientHeight               => TApplication():Define():ClientHeight()
#xtranslate <p:Application,App>.ClientWidth := <arg>       => TApplication():Define():ClientWidth( <arg> )
#xtranslate <p:Application,App>.ClientWidth                => TApplication():Define():ClientWidth()
#xtranslate <p:Application,App>.Col := <arg>               => TApplication():Define():Col( <arg> )
#xtranslate <p:Application,App>.Col                        => TApplication():Define():Col()
#xtranslate <p:Application,App>.Cursor := <arg>            => TApplication():Define():Cursor( <arg> )
#xtranslate <p:Application,App>.Cursor                     => TApplication():Define():Cursor()
#xtranslate <p:Application,App>.DoEvents                   => ProcessMessages()
#xtranslate <p:Application,App>.Drive                      => TApplication():Define():Drive
#xtranslate <p:Application,App>.ErrorLevel                 => TApplication():Define():ErrorLevel
#xtranslate <p:Application,App>.ExeName                    => TApplication():Define():ExeName
#xtranslate <p:Application,App>.FileName                   => TApplication():Define():FileName
#xtranslate <p:Application,App>.FormName                   => TApplication():Define():MainName()
#xtranslate <p:Application,App>.FormObject                 => TApplication():Define():MainObject()
#xtranslate <p:Application,App>.Handle                     => TApplication():Define():Handle()
#xtranslate <p:Application,App>.Height := <arg>            => TApplication():Define():Height( <arg> )
#xtranslate <p:Application,App>.Height                     => TApplication():Define():Height()
#xtranslate <p:Application,App>.HelpButton := <arg>        => TApplication():Define():HelpButton( <arg> )
#xtranslate <p:Application,App>.HelpButton                 => TApplication():Define():HelpButton()
#xtranslate <p:Application,App>.hWnd                       => TApplication():Define():Handle()
#xtranslate <p:Application,App>.Icon := <arg>              => TApplication():Define():Icon( <arg> )
#xtranslate <p:Application,App>.Icon                       => TApplication():Define():Icon()
#xtranslate <p:Application,App>.MainName                   => TApplication():Define():MainName()
#xtranslate <p:Application,App>.MainObject                 => TApplication():Define():MainObject()
#xtranslate <p:Application,App>.MultipleInstances := <arg> => TApplication():Define():MultipleInstances( <arg> )
#xtranslate <p:Application,App>.Name                       => TApplication():Define():Name
#xtranslate <p:Application,App>.Path                       => TApplication():Define():Path
#xtranslate <p:Application,App>.Row := <arg>               => TApplication():Define():Row( <arg> )
#xtranslate <p:Application,App>.Row                        => TApplication():Define():Row()
#xtranslate <p:Application,App>.Title := <arg>             => TApplication():Define():Title( <arg> )
#xtranslate <p:Application,App>.Title                      => TApplication():Define():Title()
#xtranslate <p:Application,App>.Topmost := <arg>           => TApplication():Define():Topmost( <arg> )
#xtranslate <p:Application,App>.Topmost                    => TApplication():Define():Topmost()
#xtranslate <p:Application,App>.Width := <arg>             => TApplication():Define():Width( <arg> )
#xtranslate <p:Application,App>.Width                      => TApplication():Define():Width()
#xtranslate <p:Application,App>.WindowStyle := <arg>       => TApplication():Define():WindowStyle( <arg> )
#xtranslate <p:Application,App>.WindowStyle                => TApplication():Define():WindowStyle()

#xtranslate SET DEFAULT ICON TO <cIcon> ;
   => ;
      _OOHG_Main_Icon := <cIcon>

#xcommand DO EVENTS ;
   => ;
      ProcessMessages()
