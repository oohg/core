/*
 * $Id: i_tooltip.ch $
 */
/*
 * ooHG source code:
 * Tooltip definitions
 *
 * Copyright 2005-2020 Ciro Vargas C. <cvc@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#xcommand SET TOOLTIPCLOSE [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipClose( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIP CLOSE [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipClose( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIPSTYLE [ TO ] CLOSE ;
   => ;
      _SetToolTipClose( .T. )

#xcommand SET TOOLTIPSTYLE [ TO ] NOCLOSE ;
   => ;
      _SetToolTipClose( .F. )

#xcommand SET TOOLTIPMULTILINE [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipMultiLine( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIP MULTILINE [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipMultiLine( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIPBALLOON [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipBalloon( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIP BALLOON [ TO ] <x: ON, OFF> ;
   => ;
      _SetToolTipBalloon( Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIPSTYLE [ TO ] BALLOON ;
   => ;
      _SetToolTipBalloon( .T. )

#xcommand SET TOOLTIPSTYLE [ TO ] STANDARD ;
   => ;
      _SetToolTipBalloon( .F. )

#xcommand SET TOOLTIP STYLE [ TO ] BALLOON ;
   => ;
      _SetToolTipBalloon( .T. )

#xcommand SET TOOLTIP STYLE [ TO ] STANDARD ;
   => ;
      _SetToolTipBalloon( .F. )

#xtranslate IsToolTipBalloonActive ;
   => ;
      _SetToolTipBalloon()

#xcommand SET TOOLTIPBACKCOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipBackColor( <aColor> )

#xcommand SET TOOLTIP BACKCOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipBackColor( <aColor> )

#xcommand SET TOOLTIPFORECOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipForeColor( <aColor> )

#xcommand SET TOOLTIP FORECOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipForeColor( <aColor> )

#xcommand SET TOOLTIPTEXTCOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipForeColor( <aColor> )

#xcommand SET TOOLTIP TEXTCOLOR [ TO ] <aColor> ;
   => ;
      _SetToolTipForeColor( <aColor> )

#xcommand SET TOOLTIPINITIALTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipInitialTime( <nMilliSec> )

#xcommand SET TOOLTIP INITIALTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipInitialTime( <nMilliSec> )

#xcommand SET TOOLTIPAUTOPOPTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipAutoPopTime( <nMilliSec> )

#xcommand SET TOOLTIP AUTOPOPTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipAutoPopTime( <nMilliSec> )

#xcommand SET TOOLTIP VISIBLETIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipAutoPopTime( <nMilliSec> )

#xcommand SET TOOLTIPRESHOWTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipReShowTime( <nMilliSec> )

#xcommand SET TOOLTIP RESHOWTIME [ TO ] <nMilliSec> ;
   => ;
      _SetToolTipReShowTime( <nMilliSec> )

#xcommand SET TOOLTIPMAXWIDTH [ TO ] <w> ;
   => ;
      _SetToolTipMaxWidth ( <w> )

#xcommand SET TOOLTIP MAXWIDTH [ TO ] <w> ;
   => ;
      _SetToolTipMaxWidth ( <w> )

#xcommand ADD TOOLTIP ICON <x> ;
   => ;
      ADD TOOLTIPICON <x>

#xcommand ADD TOOLTIPICON <icon> WITH <dummy1: MESSAGE, TITLE> <title> <dummy2: TO, OF> <form> ;
   => ;
      WITH OBJECT GetExistingFormObject( <(form)> ) ;;
         :ToolTipIcon( icon ) ;;
         :ToolTipTitle( title ) ;;
      END OBJECT

#xcommand ADD TOOLTIPICON <icon: ERROR, ERROR_LARGE, INFO, INFO_LARGE, WARNING, WARNING_LARGE> ;
      WITH <dummy1: MESSAGE, TITLE> <title> <dummy2: TO, OF> <form> ;
   => ;
      WITH OBJECT GetExistingFormObject( <(form)> ) ;;
         :ToolTipIcon( TTI_<icon> ) ;;
         :ToolTipTitle( <title> ) ;;
      END OBJECT

#xcommand CLEAR TOOLTIPICON OF <form> ;
   => ;
      WITH OBJECT GetExistingFormObject( <(form)> ) ;;
         :ToolTipIcon( TTI_NONE ) ;;
         :ToolTipTitle( "" ) ;;
      END OBJECT

#xcommand SET TOOLTIP [ACTIVATE] <x: ON, OFF> OF <form> ;
   => ;
      TTM_Activate( GetExistingFormObject( <(form)> ):ToolTiphWnd(), Upper( <(x)> ) == "ON" )

#xcommand SET TOOLTIP [ACTIVATE] TO <t> OF <form> ;
   => ;
      TTM_Activate( GetExistingFormObject( <(form)> ):ToolTiphWnd(), <t> )

#xcommand SET TOOLTIP [ACTIVATE] <x: ON, OFF> ;
   => ;
      _SetToolTipActivate( Upper( <(x)> ) == "ON" )
