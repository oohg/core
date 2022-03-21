/*
 * $Id: i_this.ch $
 */
/*
 * ooHG source code:
 * THIS semi-object definitions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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


/*---------------------------------------------------------------------------
FORMS & CONTROLS
---------------------------------------------------------------------------*/

#xtranslate This . <p: Hide, Release, Save, SaveData, SetFocus, Show> [ () ] ;
   => ;
      _OOHG_ThisObject:<p>()

#xtranslate This . <p: BackColor, BackColorCode, Caption, Cargo, ClientHeight, ;
      ClientWidth, Col, Cursor, Enabled, Handle, Height, hWnd, Name, Object, ;
      Row, VirtualHeight, VirtualWidth, Visible, Width> ;
   => ;
      _OOHG_ThisObject:<p>

/*---------------------------------------------------------------------------
FORMS
---------------------------------------------------------------------------*/

#xtranslate This . <p: Closable, FocusedControl, HelpButton, MaxButton, ;
      MaxHeight, MaxWidth, MinButton, MinHeight, MinWidth, NotifyIcon, ;
      NotifyToolTip, Sizable, SysMenu, Title, TitleBar, Topmost> ;
   => ;
      _OOHG_ThisForm:<p>

#xtranslate This . <p: Activate, Center, Maximize, Minimize, Print, Redraw, ;
      Restore, SaveAs> [ () ] ;
   => ;
      _OOHG_ThisForm:<p>()

#xtranslate ThisForm . <p: Names, Controls> ;
   => ;
      _OOHG_ThisForm:ControlsNames()

#xtranslate ThisForm . <p: BackColor, BackColorCode, Caption, Cargo, ;
      ClientHeight, ClientWidth, Closable, Col, Cursor, Enabled, ;
      FocusedControl, Handle, Height, HelpButton, hWnd, MaxButton, MaxHeight, ;
      MaxWidth, MinButton, MinHeight, MinWidth, Name, NotifyIcon, ;
      NotifyToolTip, Object, OnNotifyClick, Row, Sizable, SysMenu, Title, ;
      TitleBar, Topmost, VirtualHeight, VirtualWidth, Visible, Width> ;
   => ;
      _OOHG_ThisForm:<p>

#xtranslate ThisForm . <p: Activate, Center, Hide, Maximize, Minimize, ;
      Print, Redraw, Release, Restore, SaveAs, SetFocus, Show> [ () ] ;
   => ;
      _OOHG_ThisForm:<p>()

/*---------------------------------------------------------------------------
CONTROLS
---------------------------------------------------------------------------*/

#xtranslate <o: This, ThisControl> . <p: Address, CaretPos, Checked, DisplayValue, ;
      FontColor, FontBold, FontItalic, FontName, FontSize, FontStrikeout, ;
      FontUnderline, ForeColor, ItemCount, Length, Picture, Position, RangeMax, ;
      RangeMin, ReadOnly, ScrollCaret, Tooltip, Value, Volume> ;
   => ;
      _OOHG_ThisControl:<p>

#xtranslate <o: This, ThisControl> . <p: Address, CaretPos, Checked, DisplayValue, ;
      FontColor, FontBold, FontItalic, FontName, FontSize, FontStrikeout, ;
      FontUnderline, ForeColor, ItemCount, Picture, RangeMax, RangeMin, ;
      ReadOnly, ScrollCaret, Speed, Tooltip, Value, Volume, Zoom> := <arg> ;
   => ;
      _OOHG_ThisControl:<p> := <arg>

#xtranslate <o: This, ThisControl> . Position := <arg> ;
   => ;
      iif( _OOHG_ThisControl:Type == "PLAYER", ;
           iif( <arg> == 0, ;
                _OOHG_ThisControl:PositionHome(), ;
                iif( <arg> == 1, ;
                     _OOHG_ThisControl:PositionEnd(), ;
                     NIL ) ), ;
           _OOHG_ThisControl:Position( <arg> ) )

#xtranslate <o: This, ThisControl> . Repeat := <arg> ;
   => ;
     iif( <arg>, _OOHG_ThisControl:RepeatOn(), _OOHG_ThisControl:RepeatOff() )

#xtranslate <o: This, ThisControl> . <p: Action, OnClick> [ () ] ;
   => ;
      _OOHG_ThisControl:DoEvent( _OOHG_ThisControl:OnClick, "CLICK" )

#xtranslate <o: This, ThisControl> . OnChange [ () ] ;
   => ;
      _OOHG_ThisControl:DoEvent( _OOHG_ThisControl:OnChange, "CHANGE" )

#xtranslate <o: This, ThisControl> . OnDblClick [ () ] ;
   => ;
      _OOHG_ThisControl:DoEvent( _OOHG_ThisControl:OnDblClick, "DBLCLICK" )

#xtranslate <o: This, ThisControl> . OnGotFocus [ () ] ;
   => ;
      _OOHG_ThisControl:DoEvent( _OOHG_ThisControl:OnGotFocus, "GOTFOCUS" )

#xtranslate <o: This, ThisControl> . OnLostFocus [ () ] ;
   => ;
      _OOHG_ThisControl:DoEvent( _OOHG_ThisControl:OnLostFocus, "LOSTFOCUS" )

#xtranslate <o: This, ThisControl> . <p: AddColumn, Refresh, DeleteAllItems, Play, Stop, ;
      Close, PlayReverse, Pause, Eject, OpenDialog, Resume> [ () ] ;
   => ;
      _OOHG_ThisControl:<p>()

#xtranslate <o: This, ThisControl> . <p: AddColumn, AddControl, AddItem, AddPage, Caption, ;
      Collapse, DeleteColumn, DeleteItem, DeletePage, Expand, Header, HidePage, ;
      Item, Open, Seek, ShowPage> ( <arg,...> ) ;
   => ;
      _OOHG_ThisControl:<p>( <arg> )

#xtranslate <o: This, ThisControl> . <p: Item, Caption, Header> ( <n> ) := <arg> ;
   => ;
      _OOHG_ThisControl:<p>( <n>, <arg> )

/*---------------------------------------------------------------------------
EVENT PROCEDURES
---------------------------------------------------------------------------*/

#xtranslate This . QueryRowIndex ;
   => ;
      _OOHG_ThisQueryRowIndex

#xtranslate This . QueryColIndex ;
   => ;
      _OOHG_ThisQueryColIndex

#xtranslate This . QueryData ;
   => ;
      _OOHG_ThisQueryData

#xtranslate This . CellRowIndex ;
   => ;
      _OOHG_ThisItemRowIndex

#xtranslate This . CellColIndex ;
   => ;
      _OOHG_ThisItemColIndex

#xtranslate This . CellRow ;
   => ;
      _OOHG_ThisItemCellRow

#xtranslate This . CellCol ;
   => ;
      _OOHG_ThisItemCellCol

#xtranslate This . CellWidth ;
   => ;
      _OOHG_ThisItemCellWidth

#xtranslate This . CellHeight ;
   => ;
      _OOHG_ThisItemCellHeight

#xtranslate This . CellValue ;
   => ;
   _OOHG_ThisItemCellValue

/*---------------------------------------------------------------------------
MISCELANEOUS
---------------------------------------------------------------------------*/

#xtranslate This : <x> ;
   => ;
      _OOHG_ThisObject:<x>

#xtranslate ThisObject : <x> ;
   => ;
      _OOHG_ThisObject:<x>

#xtranslate ThisWindow : <x> ;
   => ;
      _OOHG_ThisForm:<x>

#xtranslate ThisForm : <x> ;
   => ;
      _OOHG_ThisForm:<x>

#xtranslate ThisControl : <x> ;
   => ;
      _OOHG_ThisControl:<x>

#xtranslate LastForm . <x> ;
   => ;
      _OOHG_LastDefinedForm:<x>

#xtranslate LastForm . <x> . <y> ;
   => ;
      _OOHG_LastDefinedForm:<x>:<y>

#xtranslate LastControl . <x> ;
   => ;
      _OOHG_LastDefinedControl:<x>

#xtranslate LastForm : <x> : <y> ;
   => ;
      _OOHG_LastDefinedForm:<x>:<y>

#xtranslate LastForm : <x> ;
   => ;
      _OOHG_LastDefinedForm:<x>

#xtranslate LastControl : <x> ;
   => ;
      _OOHG_LastDefinedControl:<x>

#xtranslate LastForm . LastControl . <y> ;
   => ;
      _OOHG_LastDefinedForm:LastControl():<y>

#xtranslate ThisWindow ;
   => ;
      ThisForm

#xtranslate This . IsControl [ () ] ;
   => ;
      ( _OOHG_ThisType == "C" )

#xtranslate This . IsForm [ () ] ;
   => ;
      ( _OOHG_ThisType == "W" )

