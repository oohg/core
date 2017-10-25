/*
 * $Id: i_app.ch,v 1.5 2017-08-25 19:26:27 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Application object definitions
 *
 * Copyright 2015-2017 Fernando Yurisich <fyurisich@oohg.org>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
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


#xtranslate App . <p: ArgC, Args, BackColor, Cargo, ClientHeight, ClientWidth, Col, Cursor, ;
      Drive, ExeName, FormName, FormObject, Handle, Height, HelpButton, hWndm Icon, MainName, ;
      MainName, MainObject, MultipleInstances, Name, Path, Row, Title, Topmost, Width> ;
   => ;
      Application.<p>

#xtranslate Application.ArgC                       => TApplication():Define():ArgC
#xtranslate Application.Args                       => TApplication():Define():Args
#xtranslate Application.BackColor                  => TApplication():Define():BackColor()
#xtranslate Application.BackColor := <arg>         => TApplication():Define():BackColor( <arg> )
#xtranslate Application.ClientHeight               => TApplication():Define():ClientHeight()
#xtranslate Application.ClientHeight := <arg>      => TApplication():Define():ClientHeight( <arg> )
#xtranslate Application.ClientWidth                => TApplication():Define():ClientWidth()
#xtranslate Application.ClientWidth := <arg>       => TApplication():Define():ClientWidth( <arg> )
#xtranslate Application.Cargo                      => TApplication():Define():Cargo()
#xtranslate Application.Cargo := <arg>             => TApplication():Define():Cargo( <arg> )
#xtranslate Application.Col                        => TApplication():Define():Col()
#xtranslate Application.Col := <arg>               => TApplication():Define():Col( <arg> )
#xtranslate Application.Cursor                     => TApplication():Define():Cursor()
#xtranslate Application.Cursor := <arg>            => TApplication():Define():Cursor( <arg> )
#xtranslate Application.Drive                      => TApplication():Define():Drive
#xtranslate Application.ExeName                    => TApplication():Define():ExeName
#xtranslate Application.FormName                   => TApplication():Define():MainName()
#xtranslate Application.FormObject                 => TApplication():Define():MainObject()
#xtranslate Application.Handle                     => TApplication():Define():Handle()
#xtranslate Application.Height                     => TApplication():Define():Height()
#xtranslate Application.Height := <arg>            => TApplication():Define():Height( <arg> )
#xtranslate Application.HelpButton                 => TApplication():Define():HelpButton()
#xtranslate Application.HelpButton := <arg>        => TApplication():Define():HelpButton( <arg> )
#xtranslate Application.hWnd                       => TApplication():Define():Handle()
#xtranslate Application.Icon                       => TApplication():Define():Icon()
#xtranslate Application.Icon := <arg>              => TApplication():Define():Icon( <arg> )
#xtranslate Application.MainName                   => TApplication():Define():MainName()
#xtranslate Application.MainObject                 => TApplication():Define():MainObject()
#xtranslate Application.MultipleInstances := <arg> => TApplication():Define():MultipleInstances( <arg> )
#xtranslate Application.Name                       => TApplication():Define():Name
#xtranslate Application.Path                       => TApplication():Define():Path
#xtranslate Application.Row                        => TApplication():Define():Row()
#xtranslate Application.Row := <arg>               => TApplication():Define():Row( <arg> )
#xtranslate Application.Title                      => TApplication():Define():Title()
#xtranslate Application.Title := <arg>             => TApplication():Define():Title( <arg> )
#xtranslate Application.Topmost                    => TApplication():Define():Topmost()
#xtranslate Application.Topmost := <arg>           => TApplication():Define():Topmost( <arg> )
#xtranslate Application.Width                      => TApplication():Define():Width()
#xtranslate Application.Width := <arg>             => TApplication():Define():Width( <arg> )
#xtranslate Application.WindowStyle                => TApplication():Define():WindowStyle()
#xtranslate Application.WindowStyle := <arg>       => TApplication():Define():WindowStyle( <arg> )

#xtranslate SET DEFAULT ICON TO <cIcon> ;
   => ;
      _OOHG_Main_Icon := <cIcon>

#xcommand DO EVENTS ;
   => ;
      ProcessMessages()
