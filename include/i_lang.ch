/*
 * $Id: i_lang.ch $
 */
/*
 * ooHG source code:
 * Language selection definitions
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

#translate SET LANGUAGE TO SPANISH ;
   => ;
      REQUEST HB_LANG_ES ;;
      HB_LANGSELECT( "ES" ) ;;
      InitMessages()

#translate SET LANGUAGE TO ENGLISH ;
   => ;
      REQUEST HB_LANG_EN ;;
      HB_LANGSELECT( "EN" ) ;;
      InitMessages()

#translate SET LANGUAGE TO FRENCH ;
   => ;
      REQUEST HB_LANG_FR ;;
      HB_LANGSELECT( "FR" ) ;;
      InitMessages()

#translate SET LANGUAGE TO PORTUGUESE ;
   => ;
      REQUEST HB_LANG_PT ;;
      HB_LANGSELECT( "PT" ) ;;
      InitMessages()

#translate SET LANGUAGE TO GERMAN ;
   => ;
      REQUEST HB_LANG_DEWIN ;;
      HB_LANGSELECT( "DEWIN" ) ;;
      InitMessages()

#translate SET LANGUAGE TO RUSSIAN ;
   => ;
      REQUEST HB_LANG_RUWIN ;;
      HB_LANGSELECT( "RUWIN" ) ;;
      InitMessages()

#translate SET LANGUAGE TO ITALIAN ;
   => ;
      REQUEST HB_LANG_IT ;;
      HB_LANGSELECT( "IT" ) ;;
      InitMessages()

#translate SET LANGUAGE TO POLISH ;
   => ;
      REQUEST HB_LANG_PLWIN ;;
      HB_LANGSELECT( "PLWIN" ) ;;
      InitMessages()

#translate SET LANGUAGE TO BASQUE ;
   => ;
      REQUEST HB_LANG_EU ;;
      HB_LANGSELECT( "EU" ) ;;
      InitMessages()

#translate SET LANGUAGE TO CROATIAN ;;
   => ;
      REQUEST HB_LANG_HR852 ;;
      HB_LANGSELECT( "HR852" ) ;;
      InitMessages()

#translate SET LANGUAGE TO SLOVENIAN ;
   => ;
      REQUEST HB_LANG_SLWIN ;;
      HB_LANGSELECT( "SLWIN" ) ;;
      InitMessages()

#translate SET LANGUAGE TO TURKISH ;
   => ;
      REQUEST HB_LANG_TR ;;
      HB_LANGSELECT( "TR" ) ;;
      InitMessages()

/*---------------------------------------------------------------------------
LANGUAGES NOT SUPPORTED BY HB_LANGSELECT()       // TODO: Check Harbour 3.2
---------------------------------------------------------------------------*/

#translate SET LANGUAGE TO FINNISH ;
   => ;
      InitMessages( "FI" )

#translate SET LANGUAGE TO DUTCH ;
   => ;
      InitMessages( "NL" )

/*---------------------------------------------------------------------------
RTL FUNCTIONALITY
---------------------------------------------------------------------------*/

#command SET GLOBALRTL ON ;
   => ;
      _OOHG_GlobalRTL( .T. )

#command SET GLOBALRTL OFF ;
   => ;
      _OOHG_GlobalRTL( .F. )
