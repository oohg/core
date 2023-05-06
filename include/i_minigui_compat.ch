/*
 * $Id: i_minigui_compat.ch $
 */
/*
 * OOHG source code:
 * MINIGUI compatibility commands
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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


#ifndef __OOHG_MINIGUI_COMPAT__
#define __OOHG_MINIGUI_COMPAT__

#include "i_windefs.ch"

#xtranslate IsWinNT() ;
   => ;
      .F.

#xtranslate IsVista() ;
   => ;
      .F.

#xtranslate IsSeven() ;
   => ;
      .F.

#xtranslate HMG_Is64Bits() ;
   => ;
      IsExe64()

#xtranslate _SetWindowBackColor( <FormHandle>, <aColor> ) ;
   => ;
      GetFormObjectByHandle( <FormHandle> ):BackColor( <aColor> )

#xtranslate CopyToClipboard( [ <x> ] ) ;
   => ;
      SETCLIPBOARDTEXT( <x> )

#xtranslate RetrieveTextFromClipboard() ;
   => ;
      GETCLIPBOARDTEXT()

#xtranslate IsThemed() ;
   => ;
      ISAPPTHEMED()

#xtranslate Random( <nMax> ) ;
   => ;
      hb_RandomInt( IFNUMERIC( <nMax>, <nMax>, 65535 ) )

#xtranslate _HMG_ThisFormName ;
   => ;
      _OOHG_ThisForm:Name

#xtranslate GetExeFileName() ;
   => ;
      GetModuleFileName()

#xtranslate IFNIL( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ( <v1> ) == NIL, <exp1>, <exp2> )

#xtranslate IFARRAY( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISARRAY( <v1> ), <exp1>, <exp2> )

#xtranslate IFBLOCK( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISBLOCK( <v1> ), <exp1>, <exp2> )

#xtranslate IFCHARACTER( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISCHARACTER( <v1> ), <exp1>, <exp2> )

#xtranslate IFCHAR( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISCHAR( <v1> ), <exp1>, <exp2> )

#xtranslate IFSTRING( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISSTRING( <v1> ), <exp1>, <exp2> )

#xtranslate IFDATE( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISDATE( <v1> ), <exp1>, <exp2> )

#xtranslate IFLOGICAL( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISLOGICAL( <v1> ), <exp1>, <exp2> )

#xtranslate IFNUMBER( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISNUMBER( <v1> ), <exp1>, <exp2> )

#xtranslate IFNUMERIC( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISNUMERIC( <v1> ), <exp1>, <exp2> )

#xtranslate IFOBJECT( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( ISOBJECT( <v1> ), <exp1>, <exp2> )

#xtranslate IFEMPTY( <v1>, <exp1>, <exp2> ) ;
   => ;
      iif( EMPTY( <v1> ), <exp1>, <exp2> )

#xtranslate _HMG_ThisFormName ;
   => ;
      _OOHG_ThisForm:Name

#command @ <row>,<col> BROWSE <name>			;
		[ <dummy1: OF,PARENT,DIALOG> <parent> ] ;
		[ WIDTH <w> ] 				;
		[ HEIGHT <h> ] 				;
		[ HEADERS <headers> ] 			;
		[ WIDTHS <widths> ] 			;
		[ FIELDS <Fields> ] 			;
		[ VALUE <value> ] 			;
		[ FONT <fontname> ] 			;
		[ SIZE <fontsize> ] 			;
		[ TOOLTIP <tooltip> ]			;
		[ ON CHANGE <change> ]  		;
		[ ON DBLCLICK <dblclick> ]  		;
		[ ON HEADCLICK <aHeadClick> ] 		;
		[ ON GOTFOCUS <gotfocus> ]		;
		[ ON LOSTFOCUS <lostfocus> ] 		;
		[ WORKAREA <workarea> ]			;
		[ <delete: DELETE, ALLOWDELETE> ]	;
		[ <style: NOLINES> ] 			;
		[ IMAGE <aImage> ] 			;
		[ JUSTIFY <aJust> ] 			;
		[ HELPID <helpid> ] 			;
		[ <bold : BOLD> ]			;
		[ <italic : ITALIC> ]			;
		[ <underline : UNDERLINE> ]		;
		[ <strikeout : STRIKEOUT> ]		;
		[ <break: BREAK> ] 			;
		[ BACKCOLOR <backcolor> ]		;
		[ FONTCOLOR <fontcolor> ]		;
		[ <lock: LOCK> ] 			;
		[ <inplace : INPLACE> ]			;
		[ <novsb: NOVSCROLL> ] 		;
		[ <append : APPEND, ALLOWAPPEND> ]	;
		[ READONLY <aReadOnly> ] 		;
		[ <d3: VALID, COLUMNVALID> <aValidFields> ];
		[ VALIDMESSAGES <aValidMessages> ]	;
		[ <edit : EDIT> ] 			;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ <d2: WHEN, COLUMNWHEN> <aWhenFields> ];
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ INPUTMASK <inputmask> ]	;
		[ <notabstop: NOTABSTOP> ]		;
		[ HEADERIMAGE <aImageHeader> ]		;
		[ <doublebuffer: PAINTDOUBLEBUFFER> ]	;
   => ;
      TOBrowse():Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <headers>, ;
            <widths>, <Fields>, <value>, <fontname>, <fontsize>, <tooltip>, <{change}>, ;
            <{dblclick}>, <aHeadClick>, <{gotfocus}>, <{lostfocus}>, <(workarea)>, ;
            <.delete.>, <.style.>, <aImage>, <aJust>, <helpid>, <.bold.>, <.italic.>, ;
            <.underline.>, <.strikeout.>, <.break.>, <backcolor>, <fontcolor>, ;
            <.lock.>, <.inplace.>, <.novsb.>, <.append.>, <aReadOnly>, <aValidFields>, ;
            <aValidMessages>, <.edit.>, <dynamicbackcolor>, <aWhenFields>, ;
            <dynamicforecolor>, <inputmask>, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
            NIL, NIL, <.notabstop.>, NIL, NIL, NIL, NIL, NIL, <aImageHeader>, NIL, NIL, ;
            NIL, NIL, NIL, <.doublebuffer.> )

#xtranslate BROWSE [ <x> ] ID <nId> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] INPUTITEMS <inputitems> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] DISPLAYITEMS <displayitems> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] COLUMNSORT <columnsort> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] ON INIT <bInit> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate BROWSE [ <x> ] PICTURE <aPict> [ <y> ] ;
   => ;
      BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] ID <nId> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] INPUTITEMS <inputitems> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] DISPLAYITEMS <displayitems> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] COLUMNSORT <columnsort> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] ON INIT <bInit> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate @ <row>,<col> BROWSE [ <x> ] PICTURE <aPict> [ <y> ] ;
   => ;
      @ <row>,<col> BROWSE [ <x> ] [ <y> ]

#xtranslate _GetAppCargo() ;
   => ;
      App.Cargo

#xtranslate CLEAN MEMORY ;
   => ;
      EmptyWorkingSet()

#xtranslate RELEASE MEMORY ;
   => ;
      CollectGarbage() ;;
      EmptyWorkingSet()

#define MNUCLR_THEME_DEFAULT      0
#define MNUCLR_THEME_XP           1
#define MNUCLR_THEME_2000         2
#define MNUCLR_THEME_DARK         3
#define MNUCLR_THEME_USER_DEFINED 99

#xcommand SET MENUTHEME DEFAULT [ OF <parent> ] ;
=> ;
// HMG_SetMenuTheme( MNUCLR_THEME_DEFAULT, <(parent)> )

#xcommand SET MENUTHEME XP [ OF <parent> ] ;
=> ;
// HMG_SetMenuTheme( MNUCLR_THEME_XP, <(parent)> )

#xcommand SET MENUTHEME 2000 [ OF <parent> ] ;
=> ;
// HMG_SetMenuTheme( MNUCLR_THEME_2000, <(parent)> )

#xcommand SET MENUTHEME DARK [ OF <parent> ] ;
=> ;
// HMG_SetMenuTheme( MNUCLR_THEME_DARK, <(parent)> )

#xcommand SET MENUTHEME USER <aUser> [ OF <parent> ] ;
=> ;
// HMG_SetMenuTheme( MNUCLR_THEME_USER_DEFINED, <(parent)>, <aUser> )

#xtranslate GetMenuColors() ;
   => ;
      _OOHG_GetMenuColor()

#define NO_ERROR                    0
#define ERROR_INVALID_FUNCTION      1
#define ERROR_FILE_NOT_FOUND        2
#define ERROR_PATH_NOT_FOUND        3
#define ERROR_TOO_MANY_OPEN_FILES   4
#define ERROR_ACCESS_DENIED         5
#define ERROR_INVALID_HANDLE        6
#define ERROR_ALREADY_EXISTS        183

#translate SET OOP [SUPPORT] <x:ON,OFF> ;
   => ;
      /* not needed: SET OOP */

#translate SET OOP [SUPPORT] TO <x> ;
   => ;
      /* not needed: SET OOP */

#xtranslate SET EVENTS FUNCTION TO <fname> [ RESULT TO <lSuccess> ] ;
   => ;
      /* not needed: SET EVENTS FUNCTION TO */

#xtranslate SET TOOLTIP TEXTCOLOR TO <color> OF <form> ;
   => ;
      SET TOOLTIP TEXTCOLOR TO <color>

#xtranslate SET TOOLTIP BACKCOLOR TO <color> OF <form> ;
   => ;
      SET TOOLTIP BACKCOLOR TO <color>

#xtranslate SET TOOLTIP MAXWIDTH TO <width> OF <form> ;
   => ;
      SET TOOLTIP MAXWIDTH TO <width>

#xtranslate SET TOOLTIP VISIBLETIME TO <t> OF <form> ;
   => ;
      SET TOOLTIP VISIBLETIME TO <t>

#xtranslate _GetSysFont() ;
   => ;
      GetDefaultFontName()

#xtranslate MENUITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate MENUITEM [ <x> ] IMAGE <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate MENUITEM [ <x> ] ICON <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { "", <mark> }

#xtranslate ITEM [ <x> ] IMAGE <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate ITEM [ <x> ] ICON <image> CHECKMARK <mark> ;
   => MENUITEM [ <x> ] IMAGE { <image>, <mark> }

#xtranslate LoadTrayIcon( [<x, ...>] ) ;
   => ;
      LoadTrayIconSmall(  <x> )

#endif
