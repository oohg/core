/*
 * $Id: i_app.ch $
 */
/*
 * OOHG source code:
 * Application object definitions
 *
 * Copyright 2015-2022 Fernando Yurisich <fyurisich@oohg.org> and contributors of
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


#xtranslate App.ArgC                       => _OOHG_AppObject():ArgC
#xtranslate App.Args                       => _OOHG_AppObject():Args
#xtranslate App.AutoScroll                 => _OOHG_AppObject():Value_Pos75
#xtranslate App.AutoScroll := <arg>        => _OOHG_AppObject():Value_Pos75( <arg> )
#xtranslate App.BackColor                  => _OOHG_AppObject():BackColor
#xtranslate App.BackColor := <arg>         => _OOHG_AppObject():BackColor( <arg> )
#xtranslate App.Cargo                      => _OOHG_AppObject():Cargo
#xtranslate App.Cargo := <arg>             => _OOHG_AppObject():Cargo( <arg> )
#xtranslate App.ClientHeight               => _OOHG_AppObject():ClientHeight
#xtranslate App.ClientHeight := <arg>      => _OOHG_AppObject():ClientHeight( <arg> )
#xtranslate App.ClientWidth                => _OOHG_AppObject():ClientWidth
#xtranslate App.ClientWidth := <arg>       => _OOHG_AppObject():ClientWidth( <arg> )
#xtranslate App.Col                        => _OOHG_AppObject():Col
#xtranslate App.Col := <arg>               => _OOHG_AppObject():Col( <arg> )
#xtranslate App.CollectGarbage( <arg> )    => _OOHG_AppObject():CollectGarbage( <arg> )
#xtranslate App.Cursor                     => _OOHG_AppObject():Cursor
#xtranslate App.Cursor := <arg>            => _OOHG_AppObject():Cursor( <arg> )
#xtranslate App.DefineFont( <arg> )        => _OOHG_AppObject():DefineLogFont( <arg> )
#xtranslate App.DoEvents                   => ProcessMessages()
#xtranslate App.Drive                      => _OOHG_AppObject():Drive
#xtranslate App.ErrorLevel                 => _OOHG_AppObject():ErrorLevel
#xtranslate App.ErrorLevel := <arg>        => _OOHG_AppObject():ErrorLevel( <arg> )
#xtranslate App.ExeName                    => _OOHG_AppObject():ExeName
#xtranslate App.FileName                   => _OOHG_AppObject():FileName
#xtranslate App.FontName                   => _OOHG_AppObject():Value_Pos07
#xtranslate App.FontSize                   => _OOHG_AppObject():Value_Pos08
#xtranslate App.FormName                   => _OOHG_AppObject():MainName
#xtranslate App.FormObject                 => _OOHG_AppObject():MainObject
#xtranslate App.GridScrollOnWheel          => _OOHG_AppObject():Value_Pos76
#xtranslate App.Handle                     => _OOHG_AppObject():Handle
#xtranslate App.Height                     => _OOHG_AppObject():Height
#xtranslate App.Height := <arg>            => _OOHG_AppObject():Height( <arg> )
#xtranslate App.HelpButton                 => _OOHG_AppObject():HelpButton
#xtranslate App.HelpButton := <arg>        => _OOHG_AppObject():HelpButton( <arg> )
#xtranslate App.hWnd                       => _OOHG_AppObject():Handle
#xtranslate App.Icon                       => _OOHG_AppObject():Icon
#xtranslate App.Icon.Handle                => LoadTrayIconSmall( GetResources(), _OOHG_AppObject():Icon, 32, 32 )
#xtranslate App.Icon := <arg>              => _OOHG_AppObject():Icon( <arg> )
#xtranslate App.IsAlreadyRunning           => IsExeRunning( _OOHG_AppObject():FileName )
#xtranslate App.LogFile                    => _OOHG_AppObject():LogFile
#xtranslate App.LogFile := <arg>           => _OOHG_AppObject():LogFile( <arg> )
#xtranslate App.MainName                   => _OOHG_AppObject():MainName
#xtranslate App.MainObject                 => _OOHG_AppObject():MainObject
#xtranslate App.MultipleInstances          => _OOHG_AppObject():Value_Pos30
#xtranslate App.MultipleInstances := <arg> => _OOHG_AppObject():Value_Pos30( <arg> )
#xtranslate App.MutexLock                  => _OOHG_AppObject():MutexLock()
#xtranslate App.MutexUnlock                => _OOHG_AppObject():MutexUnlock()
#xtranslate App.Name                       => _OOHG_AppObject():Name
#xtranslate App.Name := <arg>              => _OOHG_AppObject():Name( <arg> )
#xtranslate App.Path                       => _OOHG_AppObject():Path
#xtranslate App.Release                    => _OOHG_AppObject():Release()
#xtranslate App.ReleaseFont( <arg> )       => _OOHG_AppObject():ReleaseLogFont( <arg> )
#xtranslate App.Row                        => _OOHG_AppObject():Row
#xtranslate App.Row := <arg>               => _OOHG_AppObject():Row( <arg> )
#xtranslate App.ScrollPage                 => _OOHG_AppObject():Value_Pos73()
#xtranslate App.ScrollPage := <arg>        => _OOHG_AppObject():Value_Pos73( <arg> )
#xtranslate App.ScrollStep                 => _OOHG_AppObject():Value_Pos74
#xtranslate App.ScrollStep := <arg>        => _OOHG_AppObject():Value_Pos74( <arg> )
#xtranslate App.Title                      => _OOHG_AppObject():Title
#xtranslate App.Title := <arg>             => _OOHG_AppObject():Title( <arg> )
#xtranslate App.Topmost                    => _OOHG_AppObject():Topmost
#xtranslate App.Topmost := <arg>           => _OOHG_AppObject():Topmost( <arg> )
#xtranslate App.Width                      => _OOHG_AppObject():Width
#xtranslate App.Width := <arg>             => _OOHG_AppObject():Width( <arg> )
#xtranslate App.WindowStyle                => _OOHG_AppObject():WindowStyle
#xtranslate App.WindowStyle := <arg>       => _OOHG_AppObject():WindowStyle( <arg> )

#xtranslate Application.<*x*> => App.<x>

#xtranslate SET DEFAULT ICON TO <cIcon> ;
   => ;
      _OOHG_AppObject():Icon( <cIcon> )

#xcommand DO EVENTS ;
   => ;
      ProcessMessages()

#xtranslate SET LOGFILE TO <name> ;
   => ;
      _OOHG_AppObject():LogFile( <(name)> )

#xtranslate SET FORM DEFAULT BACKCOLOR TO <color>;
   => ;
      _OOHG_AppObject():Value_Pos68( <color> )

#xtranslate SET SCROLLPAGE TO <step> ;
   => ;
      _OOHG_AppObject():Value_Pos73( <step> )

#xtranslate SET SCROLLSTEP TO <step> ;
   => ;
      _OOHG_AppObject():Value_Pos74( <step> )

#xtranslate SET AUTOSCROLL OFF ;
   => ;
      _OOHG_AppObject():Value_Pos75 := .F.

#xtranslate SET AUTOSCROLL ON ;
   => ;
      _OOHG_AppObject():Value_Pos75 := .T.

#xtranslate <p:System,Sys>.AsteriskSound           => PLAYASTERISK()
#xtranslate <p:System,Sys>.BeepSound               => PLAYBEEP()
#xtranslate <p:System,Sys>.Cargo                   => _OOHG_AppObject():Cargo
#xtranslate <p:System,Sys>.ClientCol               => GETDESKTOPAREA()\[ 1 \]
#xtranslate <p:System,Sys>.ClientHeight            => GETDESKTOPREALHEIGHT()
#xtranslate <p:System,Sys>.ClientRow               => GETDESKTOPAREA()\[ 2 \]
#xtranslate <p:System,Sys>.ClientWidth             => GETDESKTOPREALWIDTH()
#xtranslate <p:System,Sys>.Clipboard               => GETCLIPBOARDTEXT()
#xtranslate <p:System,Sys>.Clipboard := <arg>      => SETCLIPBOARDTEXT( <arg> )
#xtranslate <p:System,Sys>.CollectGarbage( <arg> ) => _OOHG_AppObject():CollectGarbage( <arg> )
#xtranslate <p:System,Sys>.DefaultPrinter          => GetDefaultPrinter()
#xtranslate <p:System,Sys>.DesktopFolder           => GetDesktopFolder()
#xtranslate <p:System,Sys>.DesktopHeight           => GETDESKTOPHEIGHT()
#xtranslate <p:System,Sys>.DesktopWidth            => GETDESKTOPWIDTH()
#xtranslate <p:System,Sys>.EmptyClipboard          => CLEARCLIPBOARD()
#xtranslate <p:System,Sys>.ExclamationSound        => PLAYEXCLAMATION()
#xtranslate <p:System,Sys>.Folder                  => GetSystemFolder()
#xtranslate <p:System,Sys>.HandSound               => PLAYHAND()
#xtranslate <p:System,Sys>.MyDocumentsFolder       => GetMyDocumentsFolder()
#xtranslate <p:System,Sys>.OkSound                 => PLAYOK()
#xtranslate <p:System,Sys>.ProgramFilesFolder      => GetProgramFilesFolder()
#xtranslate <p:System,Sys>.QuestionSound           => PLAYQUESTION()
#xtranslate <p:System,Sys>.SystemFolder            => GetSystemFolder()
#xtranslate <p:System,Sys>.TempFolder              => GetTempFolder()
#xtranslate <p:System,Sys>.UserTempFolder          => GetUserTempFolder()
#xtranslate <p:System,Sys>.WindowsFolder           => GetWindowsFolder()

/*
#xtranslate LoadTrayIcon( [<x, ...>] ) ;
   => ;
      LoadTrayIconSmall(  <x> )
*/
