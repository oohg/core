/*
 * $Id: i_lang.ch $
 */
/*
 * ooHG source code:
 * Language selection definitions
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
Languages supported by hb_langSelect()
---------------------------------------------------------------------------*/

#translate SET LANGUAGE TO ENGLISH    => REQUEST HB_LANG_EN ; hb_langSelect( "EN" ) ; InitMessages()
#translate SET LANGUAGE TO SPANISH    => REQUEST HB_LANG_ES ; hb_langSelect( "ES" ) ; InitMessages()
#translate SET LANGUAGE TO FRENCH     => REQUEST HB_LANG_FR ; hb_langSelect( "FR" ) ; InitMessages()
#translate SET LANGUAGE TO PORTUGUESE => REQUEST HB_LANG_PT ; hb_langSelect( "PT" ) ; InitMessages()
#translate SET LANGUAGE TO ITALIAN    => REQUEST HB_LANG_IT ; hb_langSelect( "IT" ) ; InitMessages()
#translate SET LANGUAGE TO BASQUE     => REQUEST HB_LANG_EU ; hb_langSelect( "EU" ) ; InitMessages()
#translate SET LANGUAGE TO DUTCH      => REQUEST HB_LANG_NL ; hb_langSelect( "NL" ) ; InitMessages()
#if ( __HARBOUR__ - 0 > 0x030200 )    // for Harbour 3.4 version
#translate SET LANGUAGE TO GERMAN     => REQUEST HB_LANG_DE ; hb_langSelect( "DE" ) ; InitMessages()
#translate SET LANGUAGE TO GREEK      => REQUEST HB_LANG_EL ; hb_langSelect( "EL" ) ; InitMessages()
#translate SET LANGUAGE TO RUSSIAN    => REQUEST HB_LANG_RU ; hb_langSelect( "RU" ) ; InitMessages() 
#translate SET LANGUAGE TO UKRAINIAN  => REQUEST HB_LANG_UK ; hb_langSelect( "UK" ) ; InitMessages()
#translate SET LANGUAGE TO POLISH     => REQUEST HB_LANG_PL ; hb_langSelect( "PL" ) ; InitMessages()
#translate SET LANGUAGE TO CROATIAN   => REQUEST HB_LANG_HR ; hb_langSelect( "HR" ) ; InitMessages()
#translate SET LANGUAGE TO SLOVENIAN  => REQUEST HB_LANG_SL ; hb_langSelect( "SL" ) ; InitMessages()
#translate SET LANGUAGE TO CZECH      => REQUEST HB_LANG_CS ; hb_langSelect( "CS" ) ; InitMessages()
#translate SET LANGUAGE TO BULGARIAN  => REQUEST HB_LANG_BG ; hb_langSelect( "BG" ) ; InitMessages()
#translate SET LANGUAGE TO HUNGARIAN  => REQUEST HB_LANG_HU ; hb_langSelect( "HU" ) ; InitMessages()
#translate SET LANGUAGE TO SLOVAK     => REQUEST HB_LANG_SK ; hb_langSelect( "SK" ) ; InitMessages()
#translate SET LANGUAGE TO TURKISH    => REQUEST HB_LANG_TR ; hb_langSelect( "TR" ) ; InitMessages()
#else
#translate SET LANGUAGE TO GERMAN     => REQUEST HB_LANG_DEWIN ; hb_langSelect( "DEWIN" ) ; InitMessages()
#translate SET LANGUAGE TO GREEK      => REQUEST HB_LANG_ELWIN ; hb_langSelect( "ELWIN" ) ; InitMessages()
#translate SET LANGUAGE TO RUSSIAN    => REQUEST HB_LANG_RUWIN ; hb_langSelect( "RUWIN" ) ; InitMessages()
#translate SET LANGUAGE TO UKRAINIAN  => REQUEST HB_LANG_UAWIN ; hb_langSelect( "UAWIN" ) ; InitMessages()
#translate SET LANGUAGE TO POLISH     => REQUEST HB_LANG_PLWIN ; hb_langSelect( "PLWIN" ) ; InitMessages()
#translate SET LANGUAGE TO CROATIAN   => REQUEST HB_LANG_HR852 ; hb_langSelect( "HR852" ) ; InitMessages()
#translate SET LANGUAGE TO SLOVENIAN  => REQUEST HB_LANG_SLWIN ; hb_langSelect( "SLWIN" ) ; InitMessages()
#translate SET LANGUAGE TO CZECH      => REQUEST HB_LANG_CSWIN ; hb_langSelect( "CSWIN" ) ; InitMessages()
#translate SET LANGUAGE TO BULGARIAN  => REQUEST HB_LANG_BGWIN ; hb_langSelect( "BGWIN" ) ; InitMessages()
#translate SET LANGUAGE TO HUNGARIAN  => REQUEST HB_LANG_HUWIN ; hb_langSelect( "HUWIN" ) ; InitMessages()
#translate SET LANGUAGE TO SLOVAK     => REQUEST HB_LANG_SKWIN ; hb_langSelect( "SKWIN" ) ; InitMessages()
#translate SET LANGUAGE TO TURKISH    => REQUEST HB_LANG_TRWIN ; hb_langSelect( "TRWIN" ) ; InitMessages()
#endif

/*---------------------------------------------------------------------------
Languages not supported by hb_langSelect()
---------------------------------------------------------------------------*/

#translate SET LANGUAGE TO FINNISH    => InitMessages( "FI" )


/*---------------------------------------------------------------------------
Codepages
---------------------------------------------------------------------------*/

#translate SET CODEPAGE TO ENGLISH    =>  hb_cdpSelect( "EN" )
#translate SET CODEPAGE TO SPANISH    =>  REQUEST HB_CODEPAGE_ESWIN ; hb_cdpSelect( "ESWIN" )
#translate SET CODEPAGE TO FRENCH     =>  REQUEST HB_CODEPAGE_FRWIN ; hb_cdpSelect( "FRWIN" )
#translate SET CODEPAGE TO PORTUGUESE =>  REQUEST HB_CODEPAGE_PT850 ; hb_cdpSelect( "PT850" )
#translate SET CODEPAGE TO ITALIAN    =>  REQUEST HB_CODEPAGE_ITWIN ; hb_cdpSelect( "ITWIN" )
#translate SET CODEPAGE TO DUTCH      =>  REQUEST HB_CODEPAGE_NL850 ; hb_cdpSelect( "NL850" )
#translate SET CODEPAGE TO GERMAN     =>  REQUEST HB_CODEPAGE_DEWIN ; hb_cdpSelect( "DEWIN" )
#translate SET CODEPAGE TO GREEK      =>  REQUEST HB_CODEPAGE_ELWIN ; hb_cdpSelect( "ELWIN" )
#ifdef __XHARBOUR__
#translate SET CODEPAGE TO RUSSIAN    =>  REQUEST HB_CODEPAGE_RUWIN ; hb_cdpSelect( "RUWIN" )
#else
#translate SET CODEPAGE TO RUSSIAN    =>  REQUEST HB_CODEPAGE_RU1251 ; hb_cdpSelect( "RU1251" )
#endif
#translate SET CODEPAGE TO UKRAINIAN  =>  REQUEST HB_CODEPAGE_UA1251 ; hb_cdpSelect( "UA1251" )
#translate SET CODEPAGE TO POLISH     =>  REQUEST HB_CODEPAGE_PLWIN ; hb_cdpSelect( "PLWIN" )
#translate SET CODEPAGE TO SLOVENIAN  =>  REQUEST HB_CODEPAGE_SLWIN ; hb_cdpSelect( "SLWIN" )
#translate SET CODEPAGE TO CZECH      =>  REQUEST HB_CODEPAGE_CSWIN ; hb_cdpSelect( "CSWIN" )
#translate SET CODEPAGE TO BULGARIAN  =>  REQUEST HB_CODEPAGE_BGWIN ; hb_cdpSelect( "BGWIN" )
#translate SET CODEPAGE TO HUNGARIAN  =>  REQUEST HB_CODEPAGE_HUWIN ; hb_cdpSelect( "HUWIN" )
#translate SET CODEPAGE TO SLOVAK     =>  REQUEST HB_CODEPAGE_SKWIN ; hb_cdpSelect( "SKWIN" )
#translate SET CODEPAGE TO TURKISH    =>  REQUEST HB_CODEPAGE_TRWIN ; hb_cdpSelect( "TRWIN" )
#translate SET CODEPAGE TO SERBIAN    =>  REQUEST HB_CODEPAGE_SRWIN ; hb_cdpSelect( "SRWIN" )
#translate SET CODEPAGE TO FINNISH    =>  REQUEST HB_CODEPAGE_FI850 ; hb_cdpSelect( "FI850" )
#translate SET CODEPAGE TO SWEDISH    =>  REQUEST HB_CODEPAGE_SVWIN ; hb_cdpSelect( "SVWIN" )

#translate SET CODEPAGE TO <code>     =>  REQUEST HB_CODEPAGE_<code> ; hb_cdpSelect( <"code"> )


/*---------------------------------------------------------------------------
Right-To-Left (RTL) functionality
---------------------------------------------------------------------------*/

#command SET GLOBALRTL ON             => _OOHG_GlobalRTL( .T. )
#command SET GLOBALRTL OFF            => _OOHG_GlobalRTL( .F. )
