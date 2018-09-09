/*
 * $Id: i_var.ch $
 */
/*
 * ooHG source code:
 * "Global variables" definitions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
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


/*---------------------------------------------------------------------------
APPLICATION WIDE VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_ActiveControlInfo      => TApplication():Define():Value_Pos01
#xtranslate _OOHG_ActiveFrame            => TApplication():Define():Value_Pos02
#xtranslate _OOHG_AdjustFont             => TApplication():Define():Value_Pos03
#xtranslate _OOHG_AdjustWidth            => TApplication():Define():Value_Pos04
#xtranslate _OOHG_AutoAdjust             => TApplication():Define():Value_Pos05
#xtranslate _OOHG_DefaultFontColor       => TApplication():Define():Value_Pos06
#xtranslate _OOHG_DefaultFontName        => TApplication():Define():Value_Pos07
#xtranslate _OOHG_DefaultFontSize        => TApplication():Define():Value_Pos08
#xtranslate _OOHG_DialogCancelled        => TApplication():Define():Value_Pos09
#xtranslate _OOHG_ExtendedNavigation     => TApplication():Define():Value_Pos10
#xtranslate _OOHG_Main                   => TApplication():Define():Value_Pos11
#xtranslate _OOHG_SameEnterDblClick      => TApplication():Define():Value_Pos12
#xtranslate _OOHG_TempWindowName         => TApplication():Define():Value_Pos13
#xtranslate _OOHG_ThisControl            => TApplication():Define():Value_Pos14
#xtranslate _OOHG_ThisEventType          => TApplication():Define():Value_Pos15
#xtranslate _OOHG_ThisForm               => TApplication():Define():Value_Pos16
#xtranslate _OOHG_ThisItemCellCol        => TApplication():Define():Value_Pos17
#xtranslate _OOHG_ThisItemCellHeight     => TApplication():Define():Value_Pos18
#xtranslate _OOHG_ThisItemCellRow        => TApplication():Define():Value_Pos19
#xtranslate _OOHG_ThisItemCellValue      => TApplication():Define():Value_Pos20
#xtranslate _OOHG_ThisItemCellWidth      => TApplication():Define():Value_Pos21
#xtranslate _OOHG_ThisItemColIndex       => TApplication():Define():Value_Pos22
#xtranslate _OOHG_ThisItemRowIndex       => TApplication():Define():Value_Pos23
#xtranslate _OOHG_ThisObject             => TApplication():Define():Value_Pos24
#xtranslate _OOHG_ThisQueryColIndex      => TApplication():Define():Value_Pos25
#xtranslate _OOHG_ThisQueryData          => TApplication():Define():Value_Pos26
#xtranslate _OOHG_ThisQueryRowIndex      => TApplication():Define():Value_Pos27
#xtranslate _OOHG_ThisType               => TApplication():Define():Value_Pos28
#xtranslate _OOHG_Main_Icon              => TApplication():Define():Value_Pos29
#xtranslate _OOHG_MultipleInstances      => TApplication():Define():Value_Pos30
#xtranslate _OOHG_ApplicationCargo       => TApplication():Define():Value_Pos31
#xtranslate _OOHG_BrowseSyncStatus       => TApplication():Define():Value_Pos32
#xtranslate _OOHG_BrowseFixedBlocks      => TApplication():Define():Value_Pos33
#xtranslate _OOHG_BrowseFixedControls    => TApplication():Define():Value_Pos34
#xtranslate _OOHG_XBrowseFixedBlocks     => TApplication():Define():Value_Pos35
#xtranslate _OOHG_XBrowseFixedControls   => TApplication():Define():Value_Pos36
#xtranslate _OOHG_GridFixedControls      => TApplication():Define():Value_Pos37
#xtranslate _OOHG_ErrorLevel             => TApplication():Define():Value_Pos38
#xtranslate _OOHG_WinReleaseSameOrder    => TApplication():Define():Value_Pos39
#xtranslate _OOHG_InitTGridControlDatas  => TApplication():Define():Value_Pos40
#xtranslate _OOHG_ComboRefresh           => TApplication():Define():Value_Pos41
#xtranslate _OOHG_SaveAsDWORD            => TApplication():Define():Value_Pos42

/*---------------------------------------------------------------------------
PSEUDO VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_LastDefinedForm    => aTail( _OOHG_RegisteredForms )
#xtranslate _OOHG_MouseCol           => _OOHG_GetMouseCol()
#xtranslate _OOHG_MouseRow           => _OOHG_GetMouseRow()
#xtranslate _OOHG_RegisteredForms    => _OOHG_FormObjects()
