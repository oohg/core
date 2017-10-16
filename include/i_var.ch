/*
 * $Id: i_var.ch,v 1.31 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * "Global variables" definitions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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


/*---------------------------------------------------------------------------
APPLICATION WIDE VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_ActiveControlInfo       => TApplication():AllVars \[   1 \]
#xtranslate _OOHG_ActiveFrame             => TApplication():AllVars \[   2 \]
#xtranslate _OOHG_AdjustFont              => TApplication():AllVars \[   3 \]
#xtranslate _OOHG_AdjustWidth             => TApplication():AllVars \[   4 \]
#xtranslate _OOHG_AutoAdjust              => TApplication():AllVars \[   5 \]
#xtranslate _OOHG_DefaultFontColor        => TApplication():AllVars \[   6 \]
#xtranslate _OOHG_DefaultFontName         => TApplication():AllVars \[   7 \]
#xtranslate _OOHG_DefaultFontSize         => TApplication():AllVars \[   8 \]
#xtranslate _OOHG_DialogCancelled         => TApplication():AllVars \[   9 \]
#xtranslate _OOHG_ExtendedNavigation      => TApplication():AllVars \[  10 \]
#xtranslate _OOHG_Main                    => TApplication():AllVars \[  11 \]
#xtranslate _OOHG_SameEnterDblClick       => TApplication():AllVars \[  12 \]
#xtranslate _OOHG_TempWindowName          => TApplication():AllVars \[  13 \]
#xtranslate _OOHG_ThisControl             => TApplication():AllVars \[  14 \]
#xtranslate _OOHG_ThisEventType           => TApplication():AllVars \[  15 \]
#xtranslate _OOHG_ThisForm                => TApplication():AllVars \[  16 \]
#xtranslate _OOHG_ThisItemCellCol         => TApplication():AllVars \[  17 \]
#xtranslate _OOHG_ThisItemCellHeight      => TApplication():AllVars \[  18 \]
#xtranslate _OOHG_ThisItemCellRow         => TApplication():AllVars \[  19 \]
#xtranslate _OOHG_ThisItemCellValue       => TApplication():AllVars \[  20 \]
#xtranslate _OOHG_ThisItemCellWidth       => TApplication():AllVars \[  21 \]
#xtranslate _OOHG_ThisItemColIndex        => TApplication():AllVars \[  22 \]
#xtranslate _OOHG_ThisItemRowIndex        => TApplication():AllVars \[  23 \]
#xtranslate _OOHG_ThisObject              => TApplication():AllVars \[  24 \]
#xtranslate _OOHG_ThisQueryColIndex       => TApplication():AllVars \[  25 \]
#xtranslate _OOHG_ThisQueryData           => TApplication():AllVars \[  26 \]
#xtranslate _OOHG_ThisQueryRowIndex       => TApplication():AllVars \[  27 \]
#xtranslate _OOHG_ThisType                => TApplication():AllVars \[  28 \]
#xtranslate _OOHG_Main_Icon               => TApplication():AllVars \[  29 \]

/*---------------------------------------------------------------------------
PSEUDO VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_LastDefinedForm    => aTail( _OOHG_RegisteredForms )
#xtranslate _OOHG_MouseCol           => _OOHG_GetMouseCol()
#xtranslate _OOHG_MouseRow           => _OOHG_GetMouseRow()
#xtranslate _OOHG_RegisteredForms    => _OOHG_FormObjects()
