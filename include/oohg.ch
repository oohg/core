/*
 * $Id: oohg.ch $
 */
/*
 * ooHG source code:
 * Main include calls
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
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


#ifndef __OOHG__

#include "oohgversion.h"
#include "common.ch"
#include "i_activex.ch"
#include "i_altsyntax.ch"
#include "i_anigif.ch"
#include "i_app.ch"
#include "i_browse.ch"
#include "i_button.ch"
#include "i_checkbox.ch"
#include "i_checklist.ch"
#include "i_color.ch"
#include "i_combobox.ch"
#include "i_comm.ch"
#include "i_controlmisc.ch"
#include "i_datepicker.ch"
#include "i_dll.ch"
#include "i_edit.ch"
#include "i_editbox.ch"
#include "i_encrypt.ch"
#include "i_exec.ch"
#include "i_font.ch"
#include "i_frame.ch"
#include "i_graph.ch"
#include "i_grid.ch"
#include "i_hb_compat.ch"
#include "i_help.ch"
#include "i_hotkeybox.ch"
#include "i_hyperlink.ch"
#include "i_image.ch"
#include "i_ini.ch"
#include "i_internal.ch"
#include "i_ipaddress.ch"
#include "i_keybd.ch"
#include "i_label.ch"
#include "i_lang.ch"
#include "i_listbox.ch"
#include "i_media.ch"
#include "i_menu.ch"
#include "i_misc.ch"
#include "i_monthcal.ch"
#include "i_picture.ch"
#include "i_progressbar.ch"
#include "i_progressmeter.ch"
#include "i_pseudofunc.ch"
#include "i_radiogroup.ch"
#include "i_region.ch"
#include "i_registry.ch"
#include "i_report.ch"
#include "i_richeditbox.ch"
#include "i_scroll.ch"
#include "i_scrsaver.ch"
#include "i_slider.ch"
#include "i_spinner.ch"
#include "i_splitbox.ch"
#include "i_status.ch"
#include "i_tab.ch"
#include "i_textarray.ch"
#include "i_textbox.ch"
#include "i_this.ch"
#include "i_timer.ch"
#include "i_toolbar.ch"
#include "i_tooltip.ch"
#include "i_tree.ch"
#include "i_var.ch"
#include "i_window.ch"
#include "i_xbrowse.ch"
#include "i_zip.ch"

#endif

#ifndef __XHARBOUR__

/*
This constant must be defined when building libraries that
include oohg.ch to avoid forcing the request on every app.
*/
#ifndef _OOHG_CONSOLEMODE_
REQUEST HB_GT_GUI_DEFAULT
#endif

REQUEST DBFNTX, DBFDBT

#endif

#if ( __HARBOUR__ - 0 > 0x030200 )                // This pp rules are only needed for Harbour 3.4 version

REQUEST GetFolder
REQUEST TRadioGroup

#endif
