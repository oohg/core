/*
 * $Id: menu.h $
 */
/*
 * ooHG source code:
 * Menu-related constants definitions
 *
 * Copyright 2018-2019 Fernando Yurisich <fyurisich@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


/* This constants are used at PRG and C levels to set and get the
   parameters that configure OWNERDRAW-menus via _OOHG_DefaultMenuParams
   array. See h_menu.prg
*/

// Array length
#define MNUPAR_COUNT                       36

// Menu colors
#define MNUCLR_MENUBARBACKGROUND1          1
#define MNUCLR_MENUBARBACKGROUND2          2
#define MNUCLR_MENUBARTEXT                 3
#define MNUCLR_MENUBARSELECTEDTEXT         4
#define MNUCLR_MENUBARGRAYEDTEXT           5
#define MNUCLR_MENUBARSELECTEDITEM1        6
#define MNUCLR_MENUBARSELECTEDITEM2        7
#define MNUCLR_MENUITEMTEXT                8
#define MNUCLR_MENUITEMSELECTEDTEXT        9
#define MNUCLR_MENUITEMGRAYEDTEXT          10
#define MNUCLR_MENUITEMBACKGROUND1         11
#define MNUCLR_MENUITEMBACKGROUND2         12
#define MNUCLR_MENUITEMSELECTEDBACKGROUND1 13
#define MNUCLR_MENUITEMSELECTEDBACKGROUND2 14
#define MNUCLR_MENUITEMGRAYEDBACKGROUND1   15
#define MNUCLR_MENUITEMGRAYEDBACKGROUND2   16
#define MNUCLR_IMAGEBACKGROUND1            17
#define MNUCLR_IMAGEBACKGROUND2            18
#define MNUCLR_SEPARATOR1                  19
#define MNUCLR_SEPARATOR2                  20
#define MNUCLR_SELECTEDITEMBORDER1         21
#define MNUCLR_SELECTEDITEMBORDER2         22
#define MNUCLR_SELECTEDITEMBORDER3         23
#define MNUCLR_SELECTEDITEMBORDER4         24
#define MNUCLR_CHECKMARK                   25
#define MNUCLR_CHECKMARKBACKGROUND         26
#define MNUCLR_CHECKMARKSQUARE             27
#define MNUCLR_CHECKMARKGRAYED             28
#define MNUCLR_COUNT                       28

// Menu cursor
#define MNUCUR_SIZE                        29
#define MNUCUR_FULL                        0
#define MNUCUR_SHORT                       1

// Separator type
#define MNUSEP_TYPE                        30
#define MNUSEP_SINGLE                      0
#define MNUSEP_DOUBLE                      1

// Separator position
#define MNUSEP_POSITION                    31
#define MNUSEP_LEFT                        0
#define MNUSEP_MIDDLE                      1
#define MNUSEP_RIGHT                       2

// Others
#define MNUGRADIENT                        32
#define MNUBOR_IS3D                        33
#define MNUBMP_SIZE                        34
#define MNUBMP_XDELTA                      35
#define MNUBMP_YDELTA                      36
