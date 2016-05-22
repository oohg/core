/*
 * $Id: i_this.ch,v 1.12 2016-05-22 23:52:23 fyurisich Exp $
 */
/*
 * ooHG source code:
 * THIS semi-object definitions
 *
 * Copyright 2007-2016 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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

/*---------------------------------------------------------------------------
COMMON (THIS)
---------------------------------------------------------------------------*/

#xtranslate This . <p: Release, Show, Hide, SetFocus, Object> [ () ] ;
   => ;
      _OOHG_ThisObject:<p>()

#xtranslate This . <p: Name, Row, Col, Width, Height, Caption, BackColor, ;
      Visible, Enabled> ;
   => ;
      _OOHG_ThisObject:<p>

/*---------------------------------------------------------------------------
WINDOWS (THIS)
---------------------------------------------------------------------------*/

#xtranslate This . <p: Title, NotifyIcon, NotifyTooltip, FocusedControl, ;
      MinWidth, MaxWidth, MinHeight, MaxHeight> ;
   => ;
      _OOHG_ThisForm:<p>

#xtranslate This . <p: Activate, Center, Maximize, Minimize, Restore> [ () ] ;
   => ;
      _OOHG_ThisForm:<p>()

/*---------------------------------------------------------------------------
WINDOWS (THISWINDOW)
---------------------------------------------------------------------------*/

#xtranslate ThisWindow . <p: Title, NotifyIcon, NotifyTooltip, FocusedControl, ;
      Name, Row, Col, Width, Height, MinWidth, MaxWidth, MinHeight, MaxHeight, ;
      ClientWidth, ClientHeight> ;
   => ;
      _OOHG_ThisForm:<p>

#xtranslate ThisWindow . <p: Activate, Center, Release, Maximize, Minimize, ;
      Restore, Show, Hide, SetFocus, Object> [ () ] ;
   => ;
      _OOHG_ThisForm:<p>()

/*---------------------------------------------------------------------------
CONTROLS
---------------------------------------------------------------------------*/

// Property without arguments
#xtranslate This . <p: FontColor, ForeColor, Value, Address, Picture, Tooltip, ;
      FontName, FontSize, FontBold, FontItalic, FontUnderline, FontStrikeout, ;
      Displayvalue, Checked, ItemCount, RangeMin, RangeMax, Length, Position, ;
      CaretPos, ScrollCaret> ;
   => ;
      GetProperty( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)> )

#xtranslate This . <p: FontColor, ForeColor, Value, ReadOnly, Address, ;
      Picture, Tooltip, FontName, FontSize, FontBold, FontItalic, ;
      FontUnderline, FontStrikeout, DisplayValue, Checked, RangeMin, RangeMax, ;
      Repeat, Speed, Volume, Zoom, Position, CaretPos, ScrollCaret> := <arg> ;
   => ;
      SetProperty( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <arg> )

// Property with 1 argument
#xtranslate This . <p: Item, Caption, Header>( <n> ) ;
   => ;
      GetProperty( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <n> )

#xtranslate This . <p: Item, Caption, Header>( <n> ) := <arg> ;
   => ;
      SetProperty( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <n>, ;
            <arg> )

// Method without arguments
#xtranslate This . <p: Refresh, DeleteAllItems, Release, Play, Stop, Close, ;
      PlayReverse, Pause, Eject, OpenDialog, Resume, Save> [ () ] ;
   => ;
      DoMethod( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)> )

// Method with 1 argument
#xtranslate This . <p: AddItem, DeleteItem, Open, Seek, DeletePage, ;
      DeleteColumn, Expand, Collapse> (<arg>) ;
   => ;
      DoMethod( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <arg> )

// Method with 2 arguments
#xtranslate This . <p: AddItem>( <arg1>, <arg2> ) ;
   => ;
      DoMethod( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <arg1>, ;
            <arg2> )

// Method with 3 arguments
#xtranslate This . <p: AddItem, AddPage>( <arg1>, <arg2>, <arg3> ) ;
   => ;
      DoMethod( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <arg1>, ;
            <arg2>, <arg3> )

// Method with 4 arguments
#xtranslate This . <p: AddControl, AddColumn> ;
      ( <arg1>, <arg2>, <arg3> , <arg4> ) ;
   => ;
      DoMethod( _OOHG_ThisForm:Name, _OOHG_ThisControl:Name, <(p)>, <arg1>, ;
            <arg2>, <arg3>, <arg4> )

/*---------------------------------------------------------------------------
EVENT PROCEDURES
---------------------------------------------------------------------------*/

#xtranslate This . QueryRowIndex ;
   => ;
      _OOHG_THISQueryRowIndex

#xtranslate This . QueryColIndex ;
   => ;
      _OOHG_THISQueryColIndex

#xtranslate This . QueryData ;
   => ;
      _OOHG_THISQueryData

#xtranslate This . CellRowIndex ;
   => ;
      _OOHG_THISItemRowIndex

#xtranslate This . CellColIndex ;
   => ;
      _OOHG_THISItemColIndex

#xtranslate This . CellRow ;
   => ;
      _OOHG_THISItemCellRow

#xtranslate This . CellCol ;
   => ;
      _OOHG_THISItemCellCol

#xtranslate This . CellWidth ;
   => ;
      _OOHG_THISItemCellWidth

#xtranslate This . CellHeight ;
   => ;
      _OOHG_THISItemCellHeight

#xtranslate This . CellValue ;
   => ;
   _OOHG_THISItemCellValue

/*---------------------------------------------------------------------------
"VIRTUAL" VARIABLES
---------------------------------------------------------------------------*/

#xtranslate This : <x> ;
   => ;
      _OOHG_ThisObject:<x>

#xtranslate ThisWindow : <x> ;
   => ;
      _OOHG_ThisForm:<x>
