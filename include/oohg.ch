/*
 * $Id: oohg.ch,v 1.14 2009-09-12 18:22:13 declan2005 Exp $
 */
/*
 * ooHG source code:
 * Main include calls
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


#ifndef __OOHG__
#define __OOHG__

#include "i_var.ch"
#include "i_media.ch"
#include "i_pseudofunc.ch"
#include "i_exec.ch"
#include "i_comm.ch"
#include "i_keybd.ch"
#include "i_checkbox.ch"
#include "i_menu.ch"
#include "i_misc.ch"
#include "i_timer.ch"
#include "i_frame.ch"
#include "i_slider.ch"
#include "i_progressbar.ch"
#include "i_progressmeter.ch"
#include "i_window.ch"
#include "i_button.ch"
#include "i_image.ch"
#include "i_radiogroup.ch"
#include "i_label.ch"
#include "i_combobox.ch"
#include "i_datepicker.ch"
#include "i_listbox.ch"
#include "i_spinner.ch"
#include "i_textbox.ch"
#include "i_editbox.ch"
#include "i_grid.ch"
#include "i_tab.ch"
#include "i_controlmisc.ch"
#include "i_color.ch"
#include "i_toolbar.ch"
#include "i_splitbox.ch"
#include "i_tree.ch"
#include "i_status.ch"
#include "i_ini.ch"
#include "i_encrypt.ch"
#include "i_help.ch"
#include "i_monthcal.ch"
#include "i_region.ch"
#include "i_socket.ch"
#include "i_ipaddress.ch"
#include "i_altsyntax.ch"
#include "i_scrsaver.ch"
#include "i_registry.ch"
#include "i_edit.ch"
#include "i_report.ch"
#include "i_lang.ch"
#include "i_this.ch"
#include "i_hyperlink.ch"
#include "i_zip.ch"
#include "i_graph.ch"
#include "i_richeditbox.ch"
#include "i_browse.ch"
#include "i_dll.ch"
#include "i_tooltip.ch"
#include "i_xbrowse.ch"
#include "i_internal.ch"
#include "i_textarray.ch"
#include "i_hotkeybox.ch"
#include "i_activex.ch"
#include "i_scroll.ch"
#include "i_picture.ch"
#include "common.ch"

#endif

#ifndef __XHARBOUR__
REQUEST HB_GT_GUI_DEFAULT
#endif
