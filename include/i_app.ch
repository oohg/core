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


#xtranslate App.ArgC                       => TApplication():Define():ArgC
#xtranslate App.Args                       => TApplication():Define():Args
#xtranslate App.BackColor := <arg>         => TApplication():Define():BackColor( <arg> )
#xtranslate App.BackColor                  => TApplication():Define():BackColor()
#xtranslate App.Cargo := <arg>             => TApplication():Define():Cargo( <arg> )
#xtranslate App.Cargo                      => TApplication():Define():Cargo()
#xtranslate App.ClientHeight := <arg>      => TApplication():Define():ClientHeight( <arg> )
#xtranslate App.ClientHeight               => TApplication():Define():ClientHeight()
#xtranslate App.ClientWidth := <arg>       => TApplication():Define():ClientWidth( <arg> )
#xtranslate App.ClientWidth                => TApplication():Define():ClientWidth()
#xtranslate App.Col := <arg>               => TApplication():Define():Col( <arg> )
#xtranslate App.Col                        => TApplication():Define():Col()
#xtranslate App.Cursor := <arg>            => TApplication():Define():Cursor( <arg> )
#xtranslate App.Cursor                     => TApplication():Define():Cursor()
#xtranslate App.DoEvents                   => ProcessMessages()
#xtranslate App.Drive                      => TApplication():Define():Drive
#xtranslate App.ErrorLevel                 => TApplication():Define():ErrorLevel
#xtranslate App.ExeName                    => TApplication():Define():ExeName
#xtranslate App.FileName                   => TApplication():Define():FileName
#xtranslate App.FormName                   => TApplication():Define():MainName()
#xtranslate App.FormObject                 => TApplication():Define():MainObject()
#xtranslate App.Handle                     => TApplication():Define():Handle()
#xtranslate App.Height := <arg>            => TApplication():Define():Height( <arg> )
#xtranslate App.Height                     => TApplication():Define():Height()
#xtranslate App.HelpButton := <arg>        => TApplication():Define():HelpButton( <arg> )
#xtranslate App.HelpButton                 => TApplication():Define():HelpButton()
#xtranslate App.hWnd                       => TApplication():Define():Handle()
#xtranslate App.Icon := <arg>              => TApplication():Define():Icon( <arg> )
#xtranslate App.Icon                       => TApplication():Define():Icon()
#xtranslate App.MainName                   => TApplication():Define():MainName()
#xtranslate App.MainObject                 => TApplication():Define():MainObject()
#xtranslate App.MultipleInstances := <arg> => TApplication():Define():MultipleInstances( <arg> )
#xtranslate App.MutexLock                  => TApplication():Define():MutexLock()
#xtranslate App.MutexUnlock                => TApplication():Define():MutexUnlock()
#xtranslate App.Name                       => TApplication():Define():Name
#xtranslate App.Path                       => TApplication():Define():Path
#xtranslate App.Row := <arg>               => TApplication():Define():Row( <arg> )
#xtranslate App.Row                        => TApplication():Define():Row()
#xtranslate App.Title := <arg>             => TApplication():Define():Title( <arg> )
#xtranslate App.Title                      => TApplication():Define():Title()
#xtranslate App.Topmost := <arg>           => TApplication():Define():Topmost( <arg> )
#xtranslate App.Topmost                    => TApplication():Define():Topmost()
#xtranslate App.Width := <arg>             => TApplication():Define():Width( <arg> )
#xtranslate App.Width                      => TApplication():Define():Width()
#xtranslate App.WindowStyle := <arg>       => TApplication():Define():WindowStyle( <arg> )
#xtranslate App.WindowStyle                => TApplication():Define():WindowStyle()

#xtranslate Application.<*x*> => App.<x>

#xtranslate SET DEFAULT ICON TO <cIcon> ;
   => ;
      _OOHG_Main_Icon := <cIcon>

#xcommand DO EVENTS ;
   => ;
      ProcessMessages()
