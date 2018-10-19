/*
 * $Id: i_font.ch $
 */
/*
 * ooHG source code:
 * Font related definitions
 *
 * Copyright 2015-2018 Fernando Yurisich <fyurisich@oohg.org>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


#ifndef __OOHG_I_FONT__
#define __OOHG_I_FONT__

/*---------------------------------------------------------------------------
CHARSET CONSTANTS
---------------------------------------------------------------------------*/

#define ANSI_CHARSET                          0
#define DEFAULT_CHARSET                       1
#define SYMBOL_CHARSET                        2
#define SHIFTJIS_CHARSET                      128
#define HANGEUL_CHARSET                       129
#define HANGUL_CHARSET                        129
#define GB2312_CHARSET                        134
#define CHINESEBIG5_CHARSET                   136
#define OEM_CHARSET                           255
#define JOHAB_CHARSET                         130
#define HEBREW_CHARSET                        177
#define ARABIC_CHARSET                        178
#define GREEK_CHARSET                         161
#define TURKISH_CHARSET                       162
#define VIETNAMESE_CHARSET                    163
#define THAI_CHARSET                          222
#define EASTEUROPE_CHARSET                    238
#define RUSSIAN_CHARSET                       204
#define MAC_CHARSET                           77
#define BALTIC_CHARSET                        186

/*---------------------------------------------------------------------------
PITCH CONSTANTS
---------------------------------------------------------------------------*/

#define FONT_DEFAULT_PITCH    0
#define FONT_FIXED_PITCH      1
#define FONT_VARIABLE_PITCH   2

/*---------------------------------------------------------------------------
TYPE CONSTANTS
---------------------------------------------------------------------------*/

#define FONT_VECTOR_TYPE      1
#define FONT_RASTER_TYPE      2
#define FONT_TRUE_TYPE        3

#endif

#command SET FONT TO <fontname>, <fontsize> ;
   => ;
      _OOHG_DefaultFontName := <fontname> ;;
      _OOHG_DefaultFontSize := <fontsize>

#command SET FONT TO <fontname>, <fontsize>, <fontcolor> ;
   => ;
      _OOHG_DefaultFontName := <fontname> ;;
      _OOHG_DefaultFontSize := <fontsize> ;;
      _OOHG_DefaultFontColor := <fontcolor>

#command DEFINE FONT <name> ;
      FONTNAME <fontname> ;
      [ SIZE <fontsize> ] ;
      [ <bold : BOLD> ] ;
      [ <italic : ITALIC> ] ;
      [ <underline : UNDERLINE> ] ;
      [ <strikeout : STRIKEOUT> ] ;
      [ <langle: ANGLE, ESCAPEMENT> <angle> ] ;
      [ CHARSET <charset> ] ;
      [ WIDTH <width> ] ;
      [ <lorient: ORIENT, ORIENTATION> <orient> ] ;
      [ <default : DEFAULT> ] ;
   => ;
      TApplication():DefineFont( <"name">, <.default.>, <fontname>, <fontsize>, <.bold.>, ;
            <.italic.>, <.underline.>, <.strikeout.>, <angle>, <charset>, ;
            <width>, <orient>, <.langle.> .AND. <.lorient.> )

#command RELEASE FONT <name> ;
   => ;
      TApplication():ReleaseFont( <"name"> )
