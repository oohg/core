/*
 * $Id: i_pseudofunc.ch $
 */
/*
 * ooHG source code:
 * Pseudo-functions definitions
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


#translate IsControlDefined( <ControlName>, <FormName> ) ;
   => ;
      _IsControlDefined( <(ControlName)>, <(FormName)> )

#translate IsWIndowActive( <FormName> ) ;
   => ;
      _IsWIndowActive( <(FormName)> )

#translate IsWindowDefined( <FormName> ) ;
   => ;
      _IsWindowDefined( <(FormName)> )

#command ASSIGN <var> VALUE <value> TYPE <type> ;
   => ;
      IF ValType( <value> ) $ ( <type> ) ;;
         <var> := ( <value> ) ;;
      ENDIF

#command ASSIGN <var> VALUE <value> TYPE <type> DEFAULT <default> ;
   => ;
      IF ValType( <value> ) $ ( <type> ) ;;
         <var> := ( <value> ) ;;
      ELSE ;;
         <var> := ( <default> ) ;;
      ENDIF

#xtranslate GetDefaultFontName() ;
   => ;
      GetSystemFont() \[1\]

#xtranslate GetDefaultFontSize() ;
   => ;
      GetSystemFont() \[2\]

#xtranslate LB_String2Array( <cData> [, <Sep> ] ) ;
   => ;
      hb_ATokens( <cData>, iif( HB_ISSTRING( <Sep> ) , <Sep> , Chr(9) ) )

#xtranslate IsWinXPOrLater() ;
   => ;
      OSIsWinXPOrLater()

#xtranslate IsVistaOrLater() ;
   => ;
      OSIsWinVistaOrLater()

#xtranslate MsgAlert( <c>, <t> ) ;
   => ;
      MsgExclamation( <c>, <t> )

#xtranslate _OOHG_SetMultiple( <lMultiple>, <lWarning> ) ;
   => ;
      TApplication():Define():MultipleInstances( <lMultiple>, <lWarning> )

#xtranslate SetBrowseFixedBlocks( <lValue> ) ;
   => ;
      _OOHG_BrowseFixedBlocks := <lValue>

#xtranslate SetBrowseFixedControls( <lValue> ) ;
   => ;
      _OOHG_BrowseFixedControls := <lValue>

#xtranslate SetBrowseSync( <lValue> ) ;
   => ;
      _OOHG_BrowseSyncStatus := <lValue>

#xtranslate SetXBrowseFixedBlocks( <lValue> ) ;
   => ;
      _OOHG_XBrowseFixedBlocks := <lValue>

#xtranslate SetXBrowseFixedControls( <lValue> ) ;
   => ;
      _OOHG_XBrowseFixedControls := <lValue>

#xtranslate SetGridFixedControls( <lValue> ) ;
   => ;
      _OOHG_GridFixedControls := <lValue>

#xtranslate MiniGuiVersion() ;
   => ;
      OOHGVersion()

#xtranslate OOHGVersion() ;
   => ;
      "OOHG Ver. 2017.08.25"
