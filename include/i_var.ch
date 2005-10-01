/*
 * $Id: i_var.ch,v 1.6 2005-10-01 15:35:10 guerra000 Exp $
 */
/*
 * ooHG source code:
 * "Global variables" definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/
/*
  Public Variables Used By MiniGui Modules
*/

MEMVAR _OOHG_AllVars

#xtranslate  _OOHG_ActiveToolBar       => _OOHG_AllVars \[   1 \]
#xtranslate  _OOHG_SplitForceBreak     => _OOHG_AllVars \[   3 \]
#xtranslate  _OOHG_ActiveSplitBox      => _OOHG_AllVars \[   4 \]
#xtranslate  _OOHG_ActiveSplitBoxParentFormName => _OOHG_AllVars \[   5 \]
#xtranslate  _OOHG_Id                  => _OOHG_AllVars \[   6 \]
#xtranslate  _OOHG_Main                => _OOHG_AllVars \[   7 \]
#xtranslate  _OOHG_MouseRow            => _OOHG_AllVars \[   8 \]
#xtranslate  _OOHG_MouseCol            => _OOHG_AllVars \[   9 \]
#xtranslate  _OOHG_ActiveForm          => _OOHG_AllVars \[  10 \]
#xtranslate  _OOHG_ActiveFrame         => _OOHG_AllVars \[  11 \]
#xtranslate  _OOHG_IsModalActive       => _OOHG_AllVars \[  12 \]

#xtranslate  _OOHG_MenuParentFormName  => _OOHG_AllVars \[  13 \]
#xtranslate  _OOHG_PopupLevel          => _OOHG_AllVars \[  14 \]
#xtranslate  _OOHG_PendingPopup        => _OOHG_AllVars \[  15 \]
#xtranslate  _OOHG_PendingSubPopup     => _OOHG_AllVars \[  16 \]
#xtranslate  _OOHG_PendingMenuDef      => _OOHG_AllVars \[  17 \]
#xtranslate  _OOHG_PopupNumber         => _OOHG_AllVars \[  18 \]
#xtranslate  _OOHG_ItemNumber          => _OOHG_AllVars \[  19 \]
#xtranslate  _OOHG_SubItemNumber       => _OOHG_AllVars \[  20 \]

#xtranslate  _OOHG_StationName         => _OOHG_AllVars \[  21 \]
#xtranslate  _OOHG_SendDataCount       => _OOHG_AllVars \[  22 \]
#xtranslate  _OOHG_CommPath            => _OOHG_AllVars \[  23 \]

#xtranslate  _OOHG_ActiveMessageBar    => _OOHG_AllVars \[  25 \]

#xtranslate  _OOHG_TempWindowName      => _OOHG_AllVars \[  26 \]

#xtranslate  _OOHG_LoadWindowActive    => _OOHG_AllVars \[  27 \]

#xtranslate  _OOHG_DefaultFontName     => _OOHG_AllVars \[  28 \]
#xtranslate  _OOHG_DefaultFontSize     => _OOHG_AllVars \[  29 \]

#xtranslate  _OOHG_ThisType            => _OOHG_AllVars \[  31 \]
#xtranslate  _OOHG_ThisForm            => _OOHG_AllVars \[  32 \]

#xtranslate  _OOHG_ThisQueryRowIndex   => _OOHG_AllVars \[  33 \]
#xtranslate  _OOHG_ThisQueryColIndex   => _OOHG_AllVars \[  34 \]
#xtranslate  _OOHG_ThisQueryData       => _OOHG_AllVars \[  35 \]

#xtranslate  _OOHG_ThisItemRowIndex    => _OOHG_AllVars \[  36 \]
#xtranslate  _OOHG_ThisItemColIndex    => _OOHG_AllVars \[  37 \]
#xtranslate  _OOHG_ThisItemCellRow     => _OOHG_AllVars \[  38 \]
#xtranslate  _OOHG_ThisItemCellCol     => _OOHG_AllVars \[  39 \]
#xtranslate  _OOHG_ThisItemCellWidth   => _OOHG_AllVars \[  40 \]
#xtranslate  _OOHG_ThisItemCellHeight  => _OOHG_AllVars \[  41 \]

#xtranslate  _OOHG_BRWLangButton       => _OOHG_AllVars \[  42 \]
#xtranslate  _OOHG_BRWLangError        => _OOHG_AllVars \[  43 \]
#xtranslate  _OOHG_ActiveSplitBoxInverted => _OOHG_AllVars \[  44 \]

#xtranslate  _OOHG_DialogCancelled     => _OOHG_AllVars \[  45 \]

#xtranslate  _OOHG_ExtendedNavigation  => _OOHG_AllVars \[  46 \]
#xtranslate  _OOHG_ThisEventType       => _OOHG_AllVars \[  47 \]

#xtranslate  _OOHG_cMacroTemp          => _OOHG_AllVars \[  48 \]

#xtranslate  _OOHG_ThisControl         => _OOHG_AllVars \[  49 \]

#xtranslate  _OOHG_InteractiveCloseStarted => _OOHG_AllVars \[  51 \]

#xtranslate  _OOHG_SetFocusExecuted    => _OOHG_AllVars \[  52 \]

#xtranslate  _OOHG_BRWLangMessage      => _OOHG_AllVars \[  53 \]

#xtranslate  _OOHG_MESSAGE             => _OOHG_AllVars \[  54 \]

#xtranslate  _OOHG_aABMLangUser        => _OOHG_AllVars \[  55 \]
#xtranslate  _OOHG_aABMLangLabel       => _OOHG_AllVars \[  56 \]
#xtranslate  _OOHG_aABMLangButton      => _OOHG_AllVars \[  57 \]
#xtranslate  _OOHG_aABMLangError       => _OOHG_AllVars \[  58 \]

#xtranslate  _OOHG_aLangButton         => _OOHG_AllVars \[  59 \]
#xtranslate  _OOHG_aLangLabel          => _OOHG_AllVars \[  60 \]
#xtranslate  _OOHG_aLangUser           => _OOHG_AllVars \[  61 \]

#xtranslate  _OOHG_IsXP                => _OOHG_AllVars \[  62 \]

#xtranslate  _OOHG_DelayedSetFocus     => _OOHG_AllVars \[  63 \]

#xtranslate  _OOHG_activemodal         => _OOHG_AllVars \[  64 \]
#xtranslate  _OOHG_ThisItemCellValue   => _OOHG_AllVars \[  65 \]