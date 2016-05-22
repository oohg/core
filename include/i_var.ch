/*
 * $Id: i_var.ch,v 1.26 2016-05-22 23:52:23 fyurisich Exp $
 */
/*
 * ooHG source code:
 * "Global variables" definitions
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
PUBLIC VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

MEMVAR _OOHG_AllVars

#xtranslate _OOHG_ActiveControlInfo  => _OOHG_AllVars \[   1 \]
#xtranslate _OOHG_ActiveFrame        => _OOHG_AllVars \[   2 \]
#xtranslate _OOHG_AdjustFont         => _OOHG_AllVArs \[   3 \]
#xtranslate _OOHG_AdjustWidth        => _OOHG_AllVArs \[   4 \]
#xtranslate _OOHG_AutoAdjust         => _OOHG_AllVars \[   5 \]
#xtranslate _OOHG_DefaultFontColor   => _OOHG_AllVars \[   6 \]
#xtranslate _OOHG_DefaultFontName    => _OOHG_AllVars \[   7 \]
#xtranslate _OOHG_DefaultFontSize    => _OOHG_AllVars \[   8 \]
#xtranslate _OOHG_DialogCancelled    => _OOHG_AllVars \[   9 \]
#xtranslate _OOHG_ExtendedNavigation => _OOHG_AllVars \[  10 \]
#xtranslate _OOHG_Main               => _OOHG_AllVars \[  11 \]
#xtranslate _OOHG_SameEnterDblClick  => _OOHG_AllVArs \[  12 \]
#xtranslate _OOHG_TempWindowName     => _OOHG_AllVars \[  13 \]
#xtranslate _OOHG_ThisControl        => _OOHG_AllVars \[  14 \]
#xtranslate _OOHG_ThisEventType      => _OOHG_AllVars \[  15 \]
#xtranslate _OOHG_ThisForm           => _OOHG_AllVars \[  16 \]
#xtranslate _OOHG_ThisItemCellCol    => _OOHG_AllVars \[  17 \]
#xtranslate _OOHG_ThisItemCellHeight => _OOHG_AllVars \[  18 \]
#xtranslate _OOHG_ThisItemCellRow    => _OOHG_AllVars \[  19 \]
#xtranslate _OOHG_ThisItemCellValue  => _OOHG_AllVars \[  20 \]
#xtranslate _OOHG_ThisItemCellWidth  => _OOHG_AllVars \[  21 \]
#xtranslate _OOHG_ThisItemColIndex   => _OOHG_AllVars \[  22 \]
#xtranslate _OOHG_ThisItemRowIndex   => _OOHG_AllVars \[  23 \]
#xtranslate _OOHG_ThisObject         => _OOHG_AllVars \[  24 \]
#xtranslate _OOHG_ThisQueryColIndex  => _OOHG_AllVars \[  25 \]
#xtranslate _OOHG_ThisQueryData      => _OOHG_AllVars \[  26 \]
#xtranslate _OOHG_ThisQueryRowIndex  => _OOHG_AllVars \[  27 \]
#xtranslate _OOHG_ThisType           => _OOHG_AllVars \[  28 \]

/*---------------------------------------------------------------------------
PSEUDO VARIABLES USED BY OOHG MODULES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_LastDefinedForm    => aTail( _OOHG_RegisteredForms )
#xtranslate _OOHG_MouseCol           => _OOHG_GetMouseCol()
#xtranslate _OOHG_MouseRow           => _OOHG_GetMouseRow()
#xtranslate _OOHG_RegisteredForms    => _OOHG_FormObjects()
