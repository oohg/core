/*
* $Id: h_pdf.prg $
*/
/*
 * ooHG source code:
 * PDF class
 *
 * Based upon
 * Original works of
 * Victor K., http://www.ihaveparts.com, and
 * Pritpal Bedi, http://www.vouchcac.com
 *
 * Copyright 2007-2018 Ciro Vargas Clemow <cvc@oohg.org>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
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


#include "oohg.ch"
#include "hbclass.ch"
#include "fileio.ch"

#define TPDF_Chr_RGB( cChar )                          Str( Asc( cChar ) / 255, 4, 2 )
#define TPDF_NumToken( cString, cDelimiter )           TPDF_AllToken( cString, cDelimiter, 0, 0 )
#define TPDF_Token( cString, cDelimiter, nPointer )    TPDF_AllToken( cString, cDelimiter, nPointer, 1 )
#define TPDF_AtToken( cString, cDelimiter, nPointer )  TPDF_AllToken( cString, cDelimiter, nPointer, 2 )

#define BOOKLEVEL     1
#define BOOKTITLE     2
#define BOOKPARENT    3
#define BOOKPREV      4
#define BOOKNEXT      5
#define BOOKFIRST     6
#define BOOKLAST      7
#define BOOKCOUNT     8
#define BOOKPAGE      9
#define BOOKCOORD    10

// Report elements
#define PARAMLEN     18  // number of report elements
#define LPI           3  // lines per inch
#define PAGESIZE      4  // page size
#define PAGEORIENT    5  // page orientation
#define PAGEX         6  // page height in dots
#define PAGEY         7  // page width in dots
#define REPORTWIDTH   8  // report width in cols
#define REPORTPAGE    9  // report page
#define REPORTLINE   10  // report line
#define PAGEBUFFER   13  // page buffer
#define REPORTOBJ    14  // current obj
#define TYPE1        16  // array of type 1 fonts
#define MARGINS      17  // recalc margins
#define HEADEREDIT   18  // edit header
/*
#define FONTNAME      1  // font name
#define FONTSIZE      2  // font size
#define FONTNAMEPREV 11  // prev font name
#define FONTSIZEPREV 12  // prev font size
#define DOCLEN       15  // document length
#define NEXTOBJ      19  // next obj
#define PDFTOP       20  // top row
#define PDFLEFT      21  // left & right margin in mm
#define PDFBOTTOM    22  // bottom row
#define HANDLE       23  // handle
#define PAGES        24  // array of pages
#define REFS         25  // array of references
#define BOOKMARK     26  // array of bookmarks
#define HEADER       27  // array of headers
#define FONTS        28  // array of report fonts
#define IMAGES       29  // array of report images
#define PAGEIMAGES   30  // array of current page images
#define PAGEFONTS    31  // array of current page fonts
#define FONTWIDTH    32  // array of fonts width's
#define OPTIMIZE     33  // optimized ?
*/

#define ALIGN_LEFT    1
#define ALIGN_CENTER  2
#define ALIGN_RIGHT   3
#define ALIGN_JUSTIFY 4

#define IMAGE_WIDTH     1
#define IMAGE_HEIGHT    2
#define IMAGE_XRES      3
#define IMAGE_YRES      4
#define IMAGE_BITS      5
#define IMAGE_FROM      6
#define IMAGE_LENGTH    7
#define IMAGE_TYPE      8   // 0.JPG, 1.TIFF, 2.BMP
#define IMAGE_PALETTE   9

#define BYTE          1
#define ASCII         2
#define SHORT         3
#define LONG          4
#define RATIONAL      5
#define SBYTE         6
#define UNDEFINED     7
#define SSHORT        8
#define SLONG         9
#define SRATIONAL    10
#define FLOAT        11
#define DOUBLE       12

#define pdf_ALICEBLUE            "F0F8FF"
#define pdf_ANTIQUEWHITE         "FAEBD7"
#define pdf_AQUA                 "00FFFF"
#define pdf_AQUAMARINE           "7FFFD4"
#define pdf_AZURE                "F0FFFF"
#define pdf_BEIGE                "F5F5DC"
#define pdf_BISQUE               "FFE4C4"
#define pdf_BLACK                "000000"
#define pdf_BLANCHEDALMOND       "FFEBCD"
#define pdf_BLUE                 "0000FF"
#define pdf_BLUEVIOLET           "8A2BE2"
#define pdf_BROWN                "A52A2A"
#define pdf_BURLYWOOD            "DEB887"
#define pdf_CADETBLUE            "5F9EA0"
#define pdf_CHARTREUSE           "7FFF00"
#define pdf_CHOCOLATE            "D2691E"
#define pdf_CORAL                "FF7F50"
#define pdf_CORNFLOWERBLUE       "6495ED"
#define pdf_CORNSILK             "FFF8DC"
#define pdf_CRIMSON              "DC143C"
#define pdf_CYAN                 "00FFFF"
#define pdf_DARKBLUE             "00008B"
#define pdf_DARKCYAN             "008B8B"
#define pdf_DARKGOLDENROD        "B8860B"
#define pdf_DARKGRAY             "A9A9A9"
#define pdf_DARKGREEN            "006400"
#define pdf_DARKKHAKI            "BDB76B"
#define pdf_DARKMAGENTA          "8B008B"
#define pdf_DARKOLIVEGREEN       "556B2F"
#define pdf_DARKORANGE           "FF8C00"
#define pdf_DARKORCHID           "9932CC"
#define pdf_DARKRED              "8B0000"
#define pdf_DARKSALMON           "E9967A"
#define pdf_DARKSEAGREEN         "8FBC8F"
#define pdf_DARKSLATEBLUE        "483D8B"
#define pdf_DARKSLATEGRAY        "2F4F4F"
#define pdf_DARKTURQUOISE        "00CED1"
#define pdf_DARKVIOLET           "9400D3"
#define pdf_DEEPPINK             "FF1493"
#define pdf_DEEPSKYBLUE          "00BFFF"
#define pdf_DIMGRAY              "696969"
#define pdf_DODGERBLUE           "1E90FF"
#define pdf_FIREBRICK            "B22222"
#define pdf_FLORALWHITE          "FFFAF0"
#define pdf_FORESTGREEN          "228B22"
#define pdf_FUCHSIA              "FF00FF"
#define pdf_GAINSBORO            "DCDCDC"
#define pdf_GHOSTWHITE           "F8F8FF"
#define pdf_GOLD                 "FFD700"
#define pdf_GOLDENROD            "DAA520"
#define pdf_GRAY                 "808080"
#define pdf_GREEN                "008000"
#define pdf_GREENYELLOW          "ADFF2F"
#define pdf_HONEYDEW             "F0FFF0"
#define pdf_HOTPINK              "FF69B4"
#define pdf_INDIANRED            "CD5C5C"
#define pdf_INDIGO               "4B0082"
#define pdf_IVORY                "FFFFF0"
#define pdf_KHAKI                "F0E68C"
#define pdf_LAVENDER             "E6E6FA"
#define pdf_LAVENDERBLUSH        "FFF0F5"
#define pdf_LAWNGREEN            "7CFC00"
#define pdf_LEMONCHIFFON         "FFFACD"
#define pdf_LIGHTBLUE            "ADD8E6"
#define pdf_LIGHTCORAL           "F08080"
#define pdf_LIGHTCYAN            "E0FFFF"
#define pdf_LIGHTGOLDENRODYELLOW "FAFAD2"
#define pdf_LIGHTGREEN           "90EE90"
#define pdf_LIGHTGREY            "D3D3D3"
#define pdf_LIGHTPINK            "FFB6C1"
#define pdf_LIGHTSALMON          "FFA07A"
#define pdf_LIGHTSEAGREEN        "20B2AA"
#define pdf_LIGHTSKYBLUE         "87CEFA"
#define pdf_LIGHTSLATEGRAY       "778899"
#define pdf_LIGHTSTEELBLUE       "B0C4DE"
#define pdf_LIGHTYELLOW          "FFFFE0"
#define pdf_LIME                 "00FF00"
#define pdf_LIMEGREEN            "32CD32"
#define pdf_LINEN                "FAF0E6"
#define pdf_MAGENTA              "FF00FF"
#define pdf_MAROON               "800000"
#define pdf_MEDIUMAQUAMARINE     "66CDAA"
#define pdf_MEDIUMBLUE           "0000CD"
#define pdf_MEDIUMORCHID         "BA55D3"
#define pdf_MEDIUMPURPLE         "9370DB"
#define pdf_MEDIUMSEAGREEN       "3CB371"
#define pdf_MEDIUMSLATEBLUE      "7B68EE"
#define pdf_MEDIUMSPRINGGREEN    "00FA9A"
#define pdf_MEDIUMTURQUOISE      "48D1CC"
#define pdf_MEDIUMVIOLETRED      "C71585"
#define pdf_MIDNIGHTBLUE         "191970"
#define pdf_MINTCREAM            "F5FFFA"
#define pdf_MISTYROSE            "FFE4E1"
#define pdf_MOCCASIN             "FFE4B5"
#define pdf_NAVAJOWHITE          "FFDEAD"
#define pdf_NAVY                 "000080"
#define pdf_OLDLACE              "FDF5E6"
#define pdf_OLIVE                "808000"
#define pdf_OLIVEDRAB            "6B8E23"
#define pdf_ORANGE               "FFA500"
#define pdf_ORANGERED            "FF4500"
#define pdf_ORCHID               "DA70D6"
#define pdf_PALEGOLDENROD        "EEE8AA"
#define pdf_PALEGREEN            "98FB98"
#define pdf_PALETURQUOISE        "AFEEEE"
#define pdf_PALEVIOLETRED        "DB7093"
#define pdf_PAPAYAWHIP           "FFEFD5"
#define pdf_PEACHPUFF            "FFDAB9"
#define pdf_PERU                 "CD853F"
#define pdf_PINK                 "FFC0CB"
#define pdf_PLUM                 "DDADDD"
#define pdf_POWDERBLUE           "B0E0E6"
#define pdf_PURPLE               "800080"
#define pdf_RED                  "FF0000"
#define pdf_ROSYBROWN            "BC8F8F"
#define pdf_ROYALBLUE            "4169E1"
#define pdf_SADDLEBROWN          "8B4513"
#define pdf_SALMON               "FA8072"
#define pdf_SANDYBROWN           "F4A460"
#define pdf_SEAGREEN             "2E8B57"
#define pdf_SEASHELL             "FFF5EE"
#define pdf_SIENNA               "A0522D"
#define pdf_SILVER               "C0C0C0"
#define pdf_SKYBLUE              "87CEEB"
#define pdf_SLATEBLUE            "6A5ACD"
#define pdf_SLATEGRAY            "708090"
#define pdf_SNOW                 "FFFAFA"
#define pdf_SPRINGGREEN          "00FF7F"
#define pdf_STEELBLUE            "4682B4"
#define pdf_TAN                  "D2B48C"
#define pdf_TEAL                 "008080"
#define pdf_THISTLE              "D8BFD8"
#define pdf_TOMATO               "FF6347"
#define pdf_TURQUOISE            "40E0D0"
#define pdf_VIOLET               "EE82EE"
#define pdf_WHEAT                "F5DEB3"
#define pdf_WHITE                "FFFFFF"
#define pdf_WHITESMOKE           "F5F5F5"
#define pdf_YELLOW               "FFFF00"
#define pdf_YELLOWGREEN          "9ACD32"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CREATE CLASS TPDF

   EXPORT:

   DATA afo1 INIT ;
        {  250,  250,  250,  250,  333,  333,  333,  389,  408,  555, ;
           420,  555,  500,  500,  500,  500,  500,  500,  500,  500, ;
           833, 1000,  833,  833,  778,  833,  778,  778,  333,  333, ;
           333,  333,  333,  333,  333,  333,  333,  333,  333,  333, ;
           500,  500,  500,  500,  564,  570,  675,  570,  250,  250, ;
           250,  250,  333,  333,  333,  333,  250,  250,  250,  250, ;
           278,  278,  278,  278,  500,  500,  500,  500,  500,  500, ;
           500,  500,  500,  500,  500,  500,  500,  500,  500,  500, ;
           500,  500,  500,  500,  500,  500,  500,  500,  500,  500, ;
           500,  500,  500,  500,  500,  500,  500,  500,  500,  500, ;
           500,  500,  500,  500,  278,  333,  333,  333,  278,  333, ;
           333,  333,  564,  570,  675,  570,  564,  570,  675,  570, ;
           564,  570,  675,  570,  444,  500,  500,  500,  921,  930, ;
           920,  832,  722,  722,  611,  667,  667,  667,  611,  667, ;
           667,  722,  667,  667,  722,  722,  722,  722,  611,  667, ;
           611,  667,  556,  611,  611,  667,  722,  778,  722,  722, ;
           722,  778,  722,  778,  333,  389,  333,  389,  389,  500, ;
           444,  500,  722,  778,  667,  667,  611,  667,  556,  611, ;
           889,  944,  833,  889,  722,  722,  667,  722,  722,  778, ;
           722,  722,  556,  611,  611,  611,  722,  778,  722,  722, ;
           667,  722,  611,  667,  556,  556,  500,  556,  611,  667, ;
           556,  611,  722,  722,  722,  722,  722,  722,  611,  667, ;
           944, 1000,  833,  889,  722,  722,  611,  667,  722,  722, ;
           556,  611,  611,  667,  556,  611,  333,  333,  389,  333, ;
           278,  278,  278,  278,  333,  333,  389,  333,  469,  581, ;
           422,  570,  500,  500,  500,  500,  333,  333,  333,  333, ;
           444,  500,  500,  500,  500,  556,  500,  500,  444,  444, ;
           444,  444,  500,  556,  500,  500,  444,  444,  444,  444, ;
           333,  333,  278,  333,  500,  500,  500,  500,  500,  556, ;
           500,  556,  278,  278,  278,  278,  278,  333,  278,  278, ;
           500,  556,  444,  500,  278,  278,  278,  278,  778,  833, ;
           722,  778,  500,  556,  500,  556,  500,  500,  500,  500, ;
           500,  556,  500,  500,  500,  556,  500,  500,  333,  444, ;
           389,  389,  389,  389,  389,  389,  278,  333,  278,  278, ;
           500,  556,  500,  556,  500,  500,  444,  444,  722,  722, ;
           667,  667,  500,  500,  444,  500,  500,  500,  444,  444, ;
           444,  444,  389,  389,  480,  394,  400,  348,  200,  220, ;
           275,  220,  480,  394,  400,  348,  541,  520,  541,  570, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,  333,  333,  389,  389, ;
           500,  500,  500,  500,  500,  500,  500,  500,  167,  167, ;
           167,  167,  500,  500,  500,  500,  500,  500,  500,  500, ;
           500,  500,  500,  500,  500,  500,  500,  500,  180,  278, ;
           214,  278,  444,  500,  556,  500,  500,  500,  500,  500, ;
           333,  333,  333,  333,  333,  333,  333,  333,  556,  556, ;
           500,  556,  556,  556,  500,  556,    0,    0,    0,    0, ;
           500,  500,  500,  500,  500,  500,  500,  500,  500,  500, ;
           500,  500,  250,  250,  250,  250,    0,    0,    0,    0, ;
           453,  540,  523,  500,  350,  350,  350,  350,  333,  333, ;
           333,  333,  444,  500,  556,  500,  444,  500,  556,  500, ;
           500,  500,  500,  500, 1000, 1000,  889, 1000, 1000, 1000, ;
          1000, 1000,    0,    0,    0,    0,  444,  500,  500,  500, ;
             0,    0,    0,    0,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,    0,    0,    0,    0, ;
           333,  333,  333,  333,  333,  333,  333,  333,    0,    0, ;
             0,    0,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333, 1000, 1000,  889, 1000,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,  889, 1000,  889,  944,    0,    0,    0,    0, ;
           276,  300,  276,  266,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
           611,  667,  556,  611,  722,  778,  722,  722,  889, 1000, ;
           944,  944,  310,  330,  310,  300,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,  667,  722,  667,  722, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,  278,  278,  278,  278,    0,    0,    0,    0, ;
             0,    0,    0,    0,  278,  278,  278,  278,  500,  500, ;
           500,  500,  722,  722,  667,  722,  500,  556,  500,  500, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0  }

   DATA afo2 INIT ;
        {  278,  278,  278,  278,  278,  333,  278,  333,  355,  474, ;
           355,  474,  556,  556,  556,  556,  556,  556,  556,  556, ;
           889,  889,  889,  889,  667,  722,  667,  722,  222,  278, ;
           222,  278,  333,  333,  333,  333,  333,  333,  333,  333, ;
           389,  389,  389,  389,  584,  584,  584,  584,  278,  278, ;
           278,  278,  333,  333,  333,  333,  278,  278,  278,  278, ;
           278,  278,  278,  278,  556,  556,  556,  556,  556,  556, ;
           556,  556,  556,  556,  556,  556,  556,  556,  556,  556, ;
           556,  556,  556,  556,  556,  556,  556,  556,  556,  556, ;
           556,  556,  556,  556,  556,  556,  556,  556,  556,  556, ;
           556,  556,  556,  556,  278,  333,  278,  333,  278,  333, ;
           278,  333,  584,  584,  584,  584,  584,  584,  584,  584, ;
           584,  584,  584,  584,  556,  611,  556,  611, 1015,  975, ;
          1015,  975,  667,  722,  667,  722,  667,  722,  667,  722, ;
           722,  722,  722,  722,  722,  722,  722,  722,  667,  667, ;
           667,  667,  611,  611,  611,  611,  778,  778,  778,  778, ;
           722,  722,  722,  722,  278,  278,  278,  278,  500,  556, ;
           500,  556,  667,  722,  667,  722,  556,  611,  556,  611, ;
           833,  833,  833,  833,  722,  722,  722,  722,  778,  778, ;
           778,  778,  667,  667,  667,  667,  778,  778,  778,  778, ;
           722,  722,  722,  722,  667,  667,  667,  667,  611,  611, ;
           611,  611,  722,  722,  722,  722,  667,  667,  667,  667, ;
           944,  944,  944,  944,  667,  667,  667,  667,  667,  667, ;
           667,  667,  611,  611,  611,  611,  278,  333,  278,  333, ;
           278,  278,  278,  278,  278,  333,  278,  333,  469,  584, ;
           469,  584,  556,  556,  556,  556,  222,  278,  222,  278, ;
           556,  556,  556,  556,  556,  611,  556,  611,  500,  556, ;
           500,  556,  556,  611,  556,  611,  556,  556,  556,  556, ;
           278,  333,  278,  333,  556,  611,  556,  611,  556,  611, ;
           556,  611,  222,  278,  222,  278,  222,  278,  222,  278, ;
           500,  556,  500,  556,  222,  278,  222,  278,  833,  889, ;
           833,  889,  556,  611,  556,  611,  556,  611,  556,  611, ;
           556,  611,  556,  611,  556,  611,  556,  611,  333,  389, ;
           333,  389,  500,  556,  500,  556,  278,  333,  278,  333, ;
           556,  611,  556,  611,  500,  556,  500,  556,  722,  778, ;
           722,  778,  500,  556,  500,  556,  500,  556,  500,  556, ;
           500,  500,  500,  500,  334,  389,  334,  389,  260,  280, ;
           260,  280,  334,  389,  334,  389,  584,  584,  584,  584, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,  333,  333,  333,  333, ;
           556,  556,  556,  556,  556,  556,  556,  556,  167,  167, ;
           167,  167,  556,  556,  556,  556,  556,  556,  556,  556, ;
           556,  556,  556,  556,  556,  556,  556,  556,  191,  238, ;
           191,  238,  333,  500,  333,  500,  556,  556,  556,  556, ;
           333,  333,  333,  333,  333,  333,  333,  333,  500,  611, ;
           500,  611,  500,  611,  500,  611,    0,    0,    0,    0, ;
           556,  556,  556,  556,  556,  556,  556,  556,  556,  556, ;
           556,  556,  278,  278,  278,  278,    0,    0,    0,    0, ;
           537,  556,  537,  556,  350,  350,  350,  350,  222,  278, ;
           222,  278,  333,  500,  333,  500,  333,  500,  333,  500, ;
           556,  556,  556,  556, 1000, 1000, 1000, 1000, 1000, 1000, ;
          1000, 1000,    0,    0,    0,    0,  611,  611,  611,  611, ;
             0,    0,    0,    0,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333,  333,  333,    0,    0,    0,    0, ;
           333,  333,  333,  333,  333,  333,  333,  333,    0,    0, ;
             0,    0,  333,  333,  333,  333,  333,  333,  333,  333, ;
           333,  333,  333,  333, 1000, 1000, 1000, 1000,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0, 1000, 1000, 1000, 1000,    0,    0,    0,    0, ;
           370,  370,  370,  370,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
           556,  611,  556,  611,  778,  778,  778,  778, 1000, 1000, ;
          1000, 1000,  365,  365,  365,  365,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0,  889,  889,  889,  889, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,  278,  278,  278,  278,    0,    0,    0,    0, ;
             0,    0,    0,    0,  222,  278,  222,  278,  611,  611, ;
           611,  611,  944,  944,  944,  944,  611,  611,  611,  611, ;
             0,    0,    0,    0,    0,    0,    0,    0,    0,    0, ;
             0,    0,    0,    0,    0,    0  }

   DATA afo3 INIT ;
        {  600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600,  600,  600,  600,  600, ;
           600,  600,  600,  600,  600,  600  }

   DATA cExecuteApp    INIT ""
   DATA cExecuteParams INIT ""
   DATA cPrintApp      INIT ""
   DATA cPrintParams   INIT ""
   DATA cFileName      INIT "file.pdf"
   DATA lIsPageActive  INIT .F.
   DATA aReport
   DATA nFontName                         //  1   font name
   DATA nFontSize                         //  2   font size
   DATA nFontNamePrev                     // 11   prev font name
   DATA nFontSizePrev                     // 12   prev font size
   DATA nHandle                           // 15   document length
   DATA nNextObj                          // 19   next obj
   DATA nPdfTop                           // 20   top row
   DATA nPdfLeft                          // 21   left & right margin in mm
   DATA nPdfBottom                        // 22   bottom row
   DATA nDocLen                           // 23   handle
   DATA aPages                            // 24   array of pages
   DATA aRefs                             // 25   array of references
   DATA aBookMarks                        // 26   array of bookmarks
   DATA aHeader                           // 27   array of headers
   DATA aFonts                            // 28   array of report fonts
   DATA aImages                           // 29   array of report images
   DATA aPageImages                       // 30   array of current page images
   DATA aPageFonts                        // 31   array of current page fonts
   DATA aFontWidth                        // 32   array of fonts width's
   DATA lOptimize                         // 33   optimized ?

   METHOD Init CONSTRUCTOR

   METHOD AtSay
   METHOD BMPInfo
   METHOD Bold
   METHOD BoldItalic
   METHOD BookAdd
   METHOD BookClose
   METHOD BookCount
   METHOD BookFirst
   METHOD BookLast
   METHOD BookNext
   METHOD BookOpen
   METHOD BookParent
   METHOD BookPrev
   METHOD Box
   METHOD Box1
   METHOD Center
   METHOD CheckLine
   METHOD Close
   METHOD CloseHeader
   METHOD ClosePage
   METHOD CreateHeader
   METHOD DeleteHeader
   METHOD DisableHeader
   METHOD DrawHeader
   METHOD EditOffHeader
   METHOD EditOnHeader
   METHOD EnableHeader
   METHOD Execute
   METHOD FilePrint
   METHOD GetFontInfo
   METHOD Header
   METHOD Image
   METHOD ImageInfo
   METHOD Italic
   METHOD JPEGInfo
   METHOD Length
   METHOD M2R
   METHOD M2X
   METHOD M2Y
   METHOD Margins
   METHOD NewLine
   METHOD NewPage
   METHOD Normal
   METHOD OpenHeader
   METHOD PageNumber
   METHOD PageOrient
   METHOD PageSize
   METHOD R2D
   METHOD R2M
   METHOD Reverse
   METHOD RJust
   METHOD SaveHeader
   METHOD SetFont
   METHOD SetLPI
   METHOD StringB
   METHOD Text
   METHOD TextCount
   METHOD TextNextPara
   METHOD TextPrint
   METHOD TIFFInfo
   METHOD UnderLine
   METHOD WriteToFile
   METHOD X2M
   METHOD Y2M
   METHOD _OOHG_Box
   METHOD _OOHG_Line
   METHOD Top
   METHOD Left
   METHOD Bottom
   METHOD Right
   METHOD Height
   METHOD Width

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Init( cFile, nWidth, lOptimize ) CLASS TPDF

   DEFAULT nWidth    TO 200
   DEFAULT lOptimize TO .F.
   DEFAULT cFile     TO ::cFileName
   ::cFileName := ParseName( cFile, "pdf" )

   ::aReport := array( PARAMLEN )

   ::aReport[ LPI ]         := 6           // in lines per inch
   ::aReport[ PAGESIZE ]    := "LETTER"
   ::aReport[ PAGEORIENT ]  := "P"
   ::aReport[ PAGEX ]       := 8.5 * 72    // in dots
   ::aReport[ PAGEY ]       := 11.0 * 72   // in dots
   ::aReport[ REPORTWIDTH ] := nWidth      // in cols
   ::aReport[ REPORTPAGE ]  := 0
   ::aReport[ REPORTLINE ]  := 0
   ::aReport[ PAGEBUFFER ]  := ""
   ::aReport[ REPORTOBJ ]   := 1
   ::aReport[ MARGINS ]     := .T.
   ::aReport[ HEADEREDIT ]  := .F.
   ::aReport[ TYPE1 ]       := { "Times-Roman", "Times-Bold", "Times-Italic", "Times-BoldItalic", ;
                                 "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Helvetica-BoldOblique", ;
                                 "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique" }

   ::nFontName     := 9
   ::nFontSize     := 10
   ::nFontNamePrev := 0
   ::nFontSizePrev := 0
   ::lIsPageActive := .F.
   ::nDocLen       := 0
   ::nNextObj      := 0
   ::nPdfTop       := 1              // top row
   ::nPdfLeft      := 10             // left & right in mm
   ::nPdfBottom    := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1 // bottom row, default "LETTER", "P", 6
   ::aPages        := {}
   ::aRefs         := { 0, 0 }
   ::aBookMarks    := {}
   ::aHeader       := {}
   ::aFonts        := {}
   ::aImages       := {}
   ::aPageImages   := {}
   ::aPageFonts    := {}
   ::lOptimize     := lOptimize
   ::nNextObj      := ::aReport[ REPORTOBJ ] + 4
   ::aFontWidth    := { ::afo1, ::afo2, ::afo3 }

   ::nHandle := FCreate( cFile )
   ::WriteToFile( "%PDF-1.3" + CRLF )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Height( cUnits ) CLASS TPDF 

   LOCAL nRet

   IF cUnits == "M"
      nRet := ::aReport[ PAGEY ] / 72 * 25.4
   ELSEIF cUnits == "R"
      nRet := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ]
   ELSE
      nRet := ::aReport[ PAGEY ]
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Width( cUnits ) CLASS TPDF

   LOCAL nRet, nWidth := 0, nArr

   IF cUnits == "M"
      nRet := ::aReport[ PAGEX ] / 72 * 25.4
   ELSEIF cUnits == "R"
      IF ::GetFontInfo( "NAME" ) == "Times"
         nArr := 1
      ELSEIF ::GetFontInfo( "NAME" ) == "Helvetica"
         nArr := 2
      ELSE
         nArr := 3
      ENDIF
      AEval( ::aFontWidth[ nArr ], { |w| nWidth := Max( nWidth, w ) } )
      // Maximun width in mm of a single character
      nWidth := nWidth * 25.4 * ::nFontSize / 720.00 / 100.00
      // Max number of characters per line
      nRet := Int( ::aReport[ PAGEX ] / 72 * 25.4 / nWidth )
   ELSE
      nRet := ::aReport[ PAGEX ]
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Left( cUnits ) CLASS TPDF

   LOCAL nRet, nWidth := 0, nArr

   IF cUnits == "M"
      nRet := ::nPdfLeft
   ELSEIF cUnits == "R"
      IF ::GetFontInfo( "NAME" ) == "Times"
         nArr := 1
      ELSEIF ::GetFontInfo( "NAME" ) == "Helvetica"
         nArr := 2
      ELSE
         nArr := 3
      ENDIF
      AEval( ::aFontWidth[ nArr ], { |w| nWidth := Max( nWidth, w ) } )
      // Maximun width in mm of a single character
      nWidth := nWidth * 25.4 * ::nFontSize / 720.00 / 100.00
      // Max number of characters at left margin
      nRet := Int( ::nPdfLeft / nWidth )
   ELSE
      nRet := ::M2X( ::nPdfLeft )
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Right( cUnits ) CLASS TPDF

   RETURN ::Width( cUnits ) - ::Left( cUnits )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Top( cUnits ) CLASS TPDF

   LOCAL nRet

   IF cUnits == "M"
      nRet := ::R2M( ::nPdfTop )
   ELSEIF cUnits == "R"
      nRet := ::nPdfTop
   ELSE
      nRet := ::R2D( ::nPdfTop )
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Bottom( cUnits ) CLASS TPDF

   LOCAL nRet

   IF cUnits == "M"
      nRet := ::R2M( ::nPdfBottom )
   ELSEIF cUnits == "R"
      nRet := ::nPdfBottom
   ELSE
      nRet := ::R2D( ::nPdfBottom )
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AtSay( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPDF

   LOCAL nFont, lReverse, nAt

   DEFAULT nRow   TO ::aReport[ REPORTLINE ]
   DEFAULT nCol   TO 0
   DEFAULT cUnits TO "R"
   DEFAULT lExact TO .F.
   DEFAULT cId    TO  ""

   IF ! ::lIsPageActive
      ::NewPage()
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFATSAY", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ! Empty( cString )
      lReverse = .F.
      IF cUnits == "M"
         nRow := ::M2Y( nRow )
         nCol := ::M2X( nCol )
      ELSEIF cUnits == "R"
         IF ! lExact
            ::CheckLine( nRow )
            nRow += ::nPdfTop
         ENDIF
         nRow := ::R2D( nRow )
         nCol := ::M2X( ::nPdfLeft ) + nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ( ::aReport[ PAGEX ] - ::M2X( ::nPdfLeft ) * 2 - 9.0 ) / 100.00
      ENDIF

      cString := ::StringB( cString )
      IF Right( cString, 1 ) == Chr( 255 )   // reverse
         cString := Left( cString, Len( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow - ::nFontSize + 2.0, nCol, ::aReport[ PAGEY ] - nRow + 2.0, nCol + ::M2X( ::Length( cString ) ) + 1, NIL, 100, "D" )
         ::aReport[ PAGEBUFFER ] += " 1 g "
         lReverse = .T.
      ELSEIF Right( cString, 1 ) == Chr( 254 )   //underline
         cString := Left( cString, Len( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow + 0.5,  nCol, ::aReport[ PAGEY ] - nRow + 1, nCol + ::M2X( ::Length( cString ) ) + 1, NIL, 100, "D" )
      ENDIF

      IF ( nAt := At( Chr( 253 ), cString ) ) > 0 // some color text inside
         ::aReport[ PAGEBUFFER ] += CRLF + ;
                                    TPDF_Chr_RGB( SubStr( cString, nAt + 1, 1 ) ) + " " + ;
                                    TPDF_Chr_RGB( SubStr( cString, nAt + 2, 1 ) ) + " " + ;
                                    TPDF_Chr_RGB( SubStr( cString, nAt + 3, 1 ) ) + " rg "
         cString := Stuff( cString, nAt, 4, "" )
      ENDIF

      nFont := AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } )
      IF ::nFontName # ::nFontNamePrev
         ::nFontNamePrev := ::nFontName
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + LTrim( Str( nFont ) ) + " " + LTrim( Transform( ::nFontSize, "999.99" ) ) + " Tf " + LTrim( Transform( nCol, "9999.99" ) ) + " " + LTrim( Transform( nRow, "9999.99" ) ) + " Td (" + cString + ") Tj ET"
      ELSEIF ::nFontSize # ::nFontSizePrev
         ::nFontSizePrev := ::nFontSize
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + LTrim( Str( nFont ) ) + " " + LTrim( Transform( ::nFontSize, "999.99" ) ) + " Tf " + LTrim( Transform( nCol, "9999.99" ) ) + " " + LTrim( Transform( nRow, "9999.99" ) ) + " Td (" + cString + ") Tj ET"
      ELSE
         ::aReport[ PAGEBUFFER ] += CRLF + "BT " + LTrim( Transform( nCol, "9999.99" ) ) + " " + LTrim( Transform( nRow, "9999.99" ) ) + " Td (" + cString + ") Tj ET"
      ENDIF
      IF lReverse
         ::aReport[ PAGEBUFFER ] += " 0 g "
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Normal() CLASS TPDF

   LOCAL cName := ::GetFontInfo( "NAME" )

   IF cName = "Times"
      ::nFontName := 1
   ELSEIF cName = "Helvetica"
      ::nFontName := 5
   ELSE
      ::nFontName := 9
   ENDIF
   AAdd( ::aPageFonts, ::nFontName )
   IF AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } ) == 0
      AAdd( ::aFonts, { ::nFontName, ++ ::nNextObj } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Italic() CLASS TPDF

   LOCAL cName := ::GetFontInfo( "NAME" )

   IF cName = "Times"
      ::nFontName := 3
   ELSEIF cName = "Helvetica"
      ::nFontName := 7
   ELSE
      ::nFontName := 11
   ENDIF
   AAdd( ::aPageFonts, ::nFontName )
   IF AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } ) == 0
      AAdd( ::aFonts, { ::nFontName, ++ ::nNextObj } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Bold() CLASS TPDF

   LOCAL cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::nFontName := 2
   ELSEIF cName == "Helvetica"
      ::nFontName := 6
   ELSEIF cName == "Courier"
      ::nFontName := 10
   ENDIF
   AAdd( ::aPageFonts, ::nFontName )
   IF AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } ) == 0
      AAdd( ::aFonts, { ::nFontName, ++ ::nNextObj } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BoldItalic() CLASS TPDF

   LOCAL cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::nFontName := 4
   ELSEIF cName == "Helvetica"
      ::nFontName := 8
   ELSEIF cName == "Courier"
      ::nFontName := 12
   ENDIF
   AAdd( ::aPageFonts, ::nFontName )
   IF AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } ) == 0
      AAdd( ::aFonts, { ::nFontName, ++ ::nNextObj } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookAdd( cTitle, nLevel, nPage, nLine ) CLASS TPDF

   AAdd( ::aBookMarks, { nLevel, AllTrim( cTitle ), 0, 0, 0, 0, 0, 0, nPage, iif( nLevel == 1, ::aReport[ PAGEY ], ::R2D( nLine ) ) } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookClose() CLASS TPDF

   ::aBookMarks := NIL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookOpen() CLASS TPDF

   ::aBookMarks := {}

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD _OOHG_Box( x1, y1, x2, y2, nBorder, cBColor, cFColor ) CLASS TPDF

   LOCAL cBoxColor, cFilColor

   DEFAULT nBorder TO 0
   DEFAULT cBColor TO ""
   DEFAULT cFColor TO ""

   IF ! ::lIsPageActive
      ::NewPage()
   ENDIF

   cBoxColor := ""
   IF ! Empty( cBColor )
      cBoxColor += " " + ;
                   TPDF_Chr_RGB( SubStr( cBColor, 2, 1 ) ) + " " + ;
                   TPDF_Chr_RGB( SubStr( cBColor, 3, 1 ) ) + " " + ;
                   TPDF_Chr_RGB( SubStr( cBColor, 4, 1 ) ) + ;
                   " rg "
      IF Empty( AllTrim( cBoxColor ) )
         cBoxColor := ""
      ENDIF
   ENDIF

   cFilColor := ""
   IF ! Empty( cFColor )
      cFilColor += " " + ;
                   TPDF_Chr_RGB( SubStr( cFColor, 2, 1 ) ) + " " + ;
                   TPDF_Chr_RGB( SubStr( cFColor, 3, 1 ) ) + " " + ;
                   TPDF_Chr_RGB( SubStr( cFColor, 4, 1 ) ) + ;
                   " rg "
      IF Empty( AllTrim( cFilColor ) )
         cFilColor := ""
      ENDIF
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFBOX", "t1", { x1, y1, x2, y2, nBorder, iif( Empty( cFilColor ), 0, 1 ), "M" } )
   ENDIF

   y1 += 0.5
   y2 += 0.5

   IF ! Empty( cFilColor )
      ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + cFilColor + ;
                                 LTrim( Str(::M2X( y1 ) ) ) + " " + ;
                                 LTrim( Str(::M2Y( x1 ) ) ) + " " + ;
                                 LTrim( Str(::M2X( y2 - y1 ) ) ) + " -" + ;
                                 LTrim( Str(::M2X( x2 - x1 ) ) ) + " re f 0 g"
   ENDIF

   /*
   % Draw a rectangle with a 1-unit red border, filled with light blue.
   1.0 0.0 0.0 RG   % Red for stroke color
   0.5 0.75 1.0 rg  % Light blue for fill color
   200 300 50 75 re % x y w h re adds a rectangular subpath with the lower left corner at (x, y) with width w and height h.
   B

   To draw a round rectangle, draw one side, a curve, another side, a curve, another sise, a curve, another side, a curve.
   Set the starting point with
   x0 y0 m
   Then draw a side, with
   x1 y1 l
   Then draw a curve, with
   x2 y2 x3 y3 x4 y4 c         x2 y2 and x3 y3 are the control points

   See PDF reference manual at
   http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/pdf_reference_1-7.pdf

   The position of the control points must be calculated, see
   http://nacho4d-nacho4d.blogspot.com/2011/05/bezier-paths-rounded-corners-rectangles.html
   */
   IF nBorder > 0
      ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + cBoxColor + ;
                                 LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2X( y2 - y1 ) ) ) + " -" + ;
                                 LTrim( Str( ::M2X( nBorder ) ) ) + " re f"
      ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + cBoxColor + ;
                                 LTrim( Str( ::M2X( y2 - nBorder ) ) ) + " " + ;
                                 LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2X( nBorder ) ) ) + " -" + ;
                                 LTrim( Str( ::M2X( x2 - x1 ) ) ) + " re f"
      ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + cBoxColor + ;
                                 LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2Y( x2 - nBorder ) ) ) + " " + ;
                                 LTrim( Str( ::M2X( y2 - y1 ) ) ) + " -" + ;
                                 LTrim( Str( ::M2X( nBorder ) ) ) + " re f"
      ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + cBoxColor + ;
                                 LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                 LTrim( Str( ::M2X( nBorder ) ) ) + " -" + ;
                                 LTrim( Str( ::M2X( x2 - x1 ) ) ) + " re f 0 g"
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD _OOHG_Line( x1, y1, x2, y2, nBorder, cBColor ) CLASS TPDF

   LOCAL cBoxColor

   DEFAULT nBorder TO 0
   DEFAULT cBColor TO ""

   IF nBorder > 0
      IF ! ::lIsPageActive
         ::NewPage()
      ENDIF

      cBoxColor := ""
      IF ! Empty( cBColor )
         cBoxColor += " " + ;
                      TPDF_Chr_RGB( SubStr( cBColor, 2, 1 ) ) + " " + ;
                      TPDF_Chr_RGB( SubStr( cBColor, 3, 1 ) ) + " " + ;
                      TPDF_Chr_RGB( SubStr( cBColor, 4, 1 ) ) + ;
                      " rg "
         IF Empty( AllTrim( cBoxColor ) )
            cBoxColor := ""
         ENDIF
      ENDIF

      IF ::aReport[ HEADEREDIT ]
         RETURN ::Header( "PDFBOX", "t1", { x1, y1, x2, y2, nBorder, 0, "M" } )
      ENDIF

      IF x1 == x2
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim( Str( ::M2X( nBorder ) ) ) + " w " + cBoxColor + ;
            LTrim( Str( ::M2X( y1 ) ) ) + " " + LTrim( Str( ::M2Y( x1 - nBorder / 2 ) ) ) + " m " + ;
            LTrim( Str( ::M2X( y2 ) ) ) + " " + LTrim( Str( ::M2Y( x2 - nBorder / 2 ) ) ) + " l " + ;
            LTrim( Str( ::M2X( y2 ) ) ) + " " + LTrim( Str( ::M2Y( x2 + nBorder ) ) ) + " l " + ;
            LTrim( Str( ::M2X( y1 ) ) ) + " " + LTrim( Str( ::M2Y( x1 + nBorder ) ) ) + " l h f"
      ELSE
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + LTrim( Str( ::M2X( nBorder ) ) ) + " w " + cBoxColor + ;
            LTrim( Str( ::M2X( y1 - nBorder / 2 ) ) ) + " " + LTrim( Str( ::M2Y( x1 ) ) ) + " m " + ;
            LTrim( Str( ::M2X( y2 - nBorder / 2 ) ) ) + " " + LTrim( Str( ::M2Y( x2 ) ) ) + " l " + ;
            LTrim( Str( ::M2X( y2 + nBorder ) ) ) + " " + LTrim( Str( ::M2Y( x2 ) ) ) + " l " + ;
            LTrim( Str( ::M2X( y1 + nBorder ) ) ) + " " + LTrim( Str( ::M2Y( x1 ) ) ) + " l h f"
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Box( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId ) CLASS TPDF

   LOCAL cBoxColor

   DEFAULT nBorder TO 0
   DEFAULT nShade  TO 0
   DEFAULT cUnits  TO "M"
   DEFAULT cColor  TO ""

   IF ! ::lIsPageActive
      ::NewPage()
   ENDIF

   cBoxColor := ""
   IF ! Empty( cColor )
      cBoxColor := " " + ;
         TPDF_Chr_RGB( SubStr( cColor, 2, 1 ) ) + " " + ;
         TPDF_Chr_RGB( SubStr( cColor, 3, 1 ) ) + " " + ;
         TPDF_Chr_RGB( SubStr( cColor, 4, 1 ) ) + " rg "
      IF Empty( AllTrim( cBoxColor ) )
         cBoxColor := ""
      ENDIF
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFBOX", cId, { x1, y1, x2, y2, nBorder, nShade, cUnits } )
   ENDIF

   // TODO: Add cUnits == "R"
   IF cUnits == "M"
      y1 += 0.5
      y2 += 0.5
      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + Transform( 1.00 - nShade / 100.00, "9.99" ) + " g " + cBoxColor + ;
                                    LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2X( y2 - y1 ) ) ) + " -" + ;
                                    LTrim( Str( ::M2X( x2 - x1 ) ) ) + " re f 0 g"
      ENDIF
      IF nBorder > 0
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2X( y2 - y1 ) ) ) + " -" + ;
                                    LTrim( Str( ::M2X( nBorder ) ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( ::M2X( y2 - nBorder ) ) ) + " " + ;
                                    LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2X( nBorder ) ) ) + " -" + ;
                                    LTrim( Str( ::M2X( x2 - x1 ) ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2Y( x2 - nBorder ) ) ) + " " + ;
                                    LTrim( Str( ::M2X( y2 - y1 ) ) ) + " -" + ;
                                    LTrim( Str( ::M2X( nBorder ) ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( ::M2X( y1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2Y( x1 ) ) ) + " " + ;
                                    LTrim( Str( ::M2X( nBorder ) ) ) + " -" + ;
                                    LTrim( Str( ::M2X( x2 - x1 ) ) ) + " re f"
      ENDIF
   ELSEIF cUnits == "D"   // "Dots"
      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + Transform( 1.00 - nShade / 100.00, "9.99" ) + " g " + cBoxColor + ;
                                    LTrim( Str( y1 ) ) + " " + ;
                                    LTrim( Str( ::aReport[ PAGEY ] - x1 ) ) + " " + ;
                                    LTrim( Str( y2 - y1 ) ) + " -" + ;
                                    LTrim( Str( x2 - x1 ) ) + " re f 0 g"
      ENDIF
      IF nBorder > 0
         /*
                     1
                  +-----+
                4 |     | 2
                  +-----+
                     3
         */
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( y1 ) ) + " " + ;
                                    LTrim( Str( ::aReport[ PAGEY ] - x1 ) ) + " " + ;
                                    LTrim( Str( y2 - y1 ) ) + " -" + ;
                                    LTrim( Str( nBorder ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( y2 - nBorder ) ) + " " + ;
                                    LTrim( Str( ::aReport[ PAGEY ] - x1 ) ) + " " + ;
                                    LTrim( Str( nBorder ) ) + " -" + ;
                                    LTrim( Str( x2 - x1 ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( y1 ) ) + " " + ;
                                    LTrim( Str( ::aReport[ PAGEY ] - x2 + nBorder ) ) + " " + ;
                                    LTrim( Str( y2 - y1 ) ) + " -" + ;
                                    LTrim( Str( nBorder ) ) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ;
                                    LTrim( Str( y1 ) ) + " " + ;
                                    LTrim( Str( ::aReport[ PAGEY ] - x1 ) ) + " " + ;
                                    LTrim( Str( nBorder ) ) + " -" + ;
                                    LTrim( Str( x2 - x1 ) ) + " re f"
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Box1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor ) CLASS TPDF

   DEFAULT nBorderWidth TO 0.5
   DEFAULT cBorderColor TO Chr( 0 ) + Chr( 0 ) + Chr( 0 )
   DEFAULT cBoxColor    TO Chr( 255 ) + Chr( 255 ) + Chr( 255 )

   IF ! ::lIsPageActive
      ::NewPage()
   ENDIF

   ::aReport[ PAGEBUFFER ] += CRLF + ;
                              TPDF_Chr_RGB( SubStr( cBorderColor, 1, 1 ) ) + " " + ;
                              TPDF_Chr_RGB( SubStr( cBorderColor, 2, 1 ) ) + " " + ;
                              TPDF_Chr_RGB( SubStr( cBorderColor, 3, 1 ) ) + ;
                              " RG" + ;
                              CRLF + ;
                              TPDF_Chr_RGB( SubStr( cBoxColor, 1, 1 ) ) + " " + ;
                              TPDF_Chr_RGB( SubStr( cBoxColor, 2, 1 ) ) + " " + ;
                              TPDF_Chr_RGB( SubStr( cBoxColor, 3, 1 ) ) + ;
                              " rg" + ;
                              CRLF + LTrim( Str( nBorderWidth ) ) + " w" + ;
                              CRLF + LTrim( Str( nLeft + nBorderWidth / 2 ) ) + " " + ;
                              CRLF + LTrim( Str( ::aReport[ PAGEY ] - nBottom + nBorderWidth / 2 ) ) + " " + ;
                              CRLF + LTrim( Str( nRight - nLeft -  nBorderWidth ) ) + ;
                              CRLF + LTrim( Str( nBottom - nTop - nBorderWidth ) ) + " " + ;
                              " re" + ;
                              CRLF + "B"

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Center( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPDF

   LOCAL nLen, nAt

   DEFAULT nRow   TO ::aReport[ REPORTLINE ]
   DEFAULT cUnits TO "R"
   DEFAULT lExact TO .F.
   DEFAULT nCol   TO iif( cUnits == "R", ::aReport[ REPORTWIDTH ] / 2, iif( cUnits == "M", ::X2M( ::aReport[ PAGEX ] ) / 2, ::aReport[ PAGEX ] / 2 ) )

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFCENTER", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := At( "#pagenumber#", cString ) ) > 0
      cString := Left( cString, nAt - 1 ) + LTrim( Str( ::PageNumber() ) ) + SubStr( cString, nAt + 12 )
   ENDIF

   IF cUnits == "M"
      nLen := ::Length( cString ) / 2
   ELSEIF cUnits == "R"
      nLen := Int( ::Length( cString, "R" ) / 2 )
   ELSE   // Dots
      nLen := Int( ::M2X( ::Length( cString ) / 2 ) )
   ENDIF

   ::AtSay( cString, nRow, nCol - nLen, cUnits, lExact )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Close() CLASS TPDF

   LOCAL nI, cTemp, nCurLevel, nObj1, nLast, nCount, nFirst, nRecno, nBooklen

   ::ClosePage()

   // kids
   ::aRefs[ 2 ] := ::nDocLen
   cTemp := "1 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Type /Pages /Count " + LTrim( Str( ::aReport[ REPORTPAGE ] ) ) + CRLF + ;
            "/Kids ["
   FOR nI := 1 TO ::aReport[ REPORTPAGE ]
      cTemp += " " + LTrim( Str( ::aPages[ nI ] ) ) + " 0 R"
   NEXT
   cTemp += " ]" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   ::WriteToFile( cTemp )

   // info
   ++ ::aReport[ REPORTOBJ ]
   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Producer ()" + CRLF + ;
            "/Title ()" + CRLF + ;
            "/Author ()" + CRLF + ;
            "/Creator ()" + CRLF + ;
            "/Subject ()" + CRLF + ;
            "/Keywords ()" + CRLF + ;
            "/CreationDate (D:" + Str( Year( Date() ), 4 ) + ;
                                  PadL( Month( Date() ), 2, "0" ) + ;
                                  PadL( Day( Date() ), 2, "0" ) + ;
                                  SubStr( Time(), 1, 2 ) + ;
                                  SubStr( Time(), 4, 2 ) + ;
                                  SubStr( Time(), 7, 2 ) + ")" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   ::WriteToFile( cTemp )

   // root
   ++ ::aReport[ REPORTOBJ ]
   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + ;
            "<< /Type /Catalog /Pages 1 0 R /Outlines " + LTrim( Str( ::aReport[ REPORTOBJ ] + 1 ) ) + ;
            " 0 R" + iif( ( nBookLen := Len( ::aBookMarks ) ) > 0, " /PageMode /UseOutlines", "" ) + ;
            " >>" + CRLF + "endobj" + CRLF
   ::WriteToFile( cTemp )

   ++ ::aReport[ REPORTOBJ ]
   nObj1 := ::aReport[ REPORTOBJ ]

   IF nBookLen > 0
      nRecno := 1
      nFirst := ::aReport[ REPORTOBJ ] + 1
      nLast  := 0
      nCount := 0
      DO WHILE nRecno <= nBookLen
         nCurLevel := ::aBookMarks[ nRecno, BOOKLEVEL ]
         ::aBookMarks[ nRecno, BOOKPARENT ] := ::BookParent( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aBookMarks[ nRecno, BOOKPREV ]   := ::BookPrev(   nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aBookMarks[ nRecno, BOOKNEXT ]   := ::BookNext(   nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aBookMarks[ nRecno, BOOKFIRST ]  := ::BookFirst(  nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aBookMarks[ nRecno, BOOKLAST ]   := ::BookLast(   nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aBookMarks[ nRecno, BOOKCOUNT ]  := ::BookCount(  nRecno, nCurLevel )
         IF nCurLevel == 1
            nLast := nRecno
            ++ nCount
         ENDIF
         ++ nRecno
      ENDDO

      nLast += ::aReport[ REPORTOBJ ]

      AAdd( ::aRefs, ::nDocLen )
      cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + ;
               "<< /Type /Outlines /Count " + LTrim( Str( nCount ) ) + ;
               " /First " + LTrim( Str( nFirst ) ) + ;
               " 0 R /Last " + LTrim( Str( nLast ) ) + ;
               " 0 R >>" + CRLF + "endobj"
      ::WriteToFile( cTemp )

      ++ ::aReport[ REPORTOBJ ]
      nRecno := 1
      FOR nI := 1 TO nBookLen
         AAdd( ::aRefs, ::nDocLen + 2 )
         cTemp := CRLF + LTrim( Str( ::aReport[ REPORTOBJ ] + nI - 1 ) ) + " 0 obj" + CRLF + ;
                  "<<" + CRLF + ;
                  "/Parent " + LTrim( Str( ::aBookMarks[ nRecno, BOOKPARENT ] ) ) + " 0 R" + CRLF + ;
                  "/Dest [" + LTrim( Str( ::aPages[ ::aBookMarks[ nRecno, BOOKPAGE ] ] ) ) + " 0 R /XYZ 0 " + LTrim( Str( ::aBookMarks[ nRecno, BOOKCOORD ] ) ) + " 0 ]" + CRLF + ;
                  "/Title (" + AllTrim( ::aBookMarks[ nRecno, BOOKTITLE ]) + " )" + CRLF + ;
                  iif( ::aBookMarks[ nRecno, BOOKPREV ] > 0,  "/Prev "  + LTrim( Str( ::aBookMarks[ nRecno, BOOKPREV ] ) )  + " 0 R" + CRLF, "" ) + ;
                  iif( ::aBookMarks[ nRecno, BOOKNEXT ] > 0,  "/Next "  + LTrim( Str( ::aBookMarks[ nRecno, BOOKNEXT ] ) )  + " 0 R" + CRLF, "" ) + ;
                  iif( ::aBookMarks[ nRecno, BOOKFIRST ] > 0, "/First " + LTrim( Str( ::aBookMarks[ nRecno, BOOKFIRST ] ) ) + " 0 R" + CRLF, "" ) + ;
                  iif( ::aBookMarks[ nRecno, BOOKLAST ] > 0,  "/Last "  + LTrim( Str( ::aBookMarks[ nRecno, BOOKLAST ] ) )  + " 0 R" + CRLF, "" ) + ;
                  iif( ::aBookMarks[ nRecno, BOOKCOUNT ] # 0, "/Count " + LTrim( Str( ::aBookMarks[ nRecno, BOOKCOUNT ] ) ) + CRLF, "" ) + ;
                  ">>" + CRLF + "endobj" + CRLF
         ::WriteToFile( cTemp )
         ++ nRecno
      NEXT
      ::BookClose()

      ::aReport[ REPORTOBJ ] += nBookLen - 1
   ELSE
      cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + "<< /Type /Outlines /Count 0 >>" + CRLF + "endobj" + CRLF
      AAdd( ::aRefs, ::nDocLen )
      ::WriteToFile( cTemp )
   ENDIF

   ::WriteToFile( CRLF )

   ++ ::aReport[ REPORTOBJ ]
   cTemp := "xref" + CRLF + ;
            "0 " + LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + CRLF +;
            PadL( ::aRefs[ 1 ], 10, "0" ) + " 65535 f" + CRLF
   FOR nI := 2 TO Len( ::aRefs )
      cTemp += PadL( ::aRefs[ nI ], 10, "0" ) + " 00000 n" + CRLF
   NEXT
   cTemp += "trailer << /Size " + LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " /Root " + LTrim( Str( nObj1 - 1 ) ) + " 0 R /Info " + LTrim( Str( nObj1 - 2 ) ) + " 0 R >>" + CRLF + ;
            "startxref" + CRLF + ;
            LTrim( Str( ::nDocLen ) ) + CRLF + ;
            "%%EOF" + CRLF
   ::WriteToFile( cTemp )

   FClose( ::nHandle )
   ::nHandle := 0

   ::aReport := NIL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Image( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId ) CLASS TPDF

   DEFAULT nRow    TO ::aReport[ REPORTLINE ]
   DEFAULT nCol    TO 0
   DEFAULT nHeight TO 0
   DEFAULT nWidth  TO 0
   DEFAULT cUnits  TO "R"
   DEFAULT cId     TO  ""

   IF ! ::lIsPageActive
      ::NewPage()
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFIMAGE", cId, { cFile, nRow, nCol, cUnits, nHeight, nWidth } )
   ENDIF

   IF cUnits == "M"
      nRow    := ::aReport[ PAGEY ] - ::M2Y( nRow )
      nCol    := ::M2X( nCol )
      nHeight := ::aReport[ PAGEY ] - ::M2Y( nHeight )
      nWidth  := ::M2X( nWidth )
   ELSEIF cUnits == "R"
      nRow    := ::aReport[ PAGEY ] - ::R2D( nRow )
      nCol    := ::M2X( ::nPdfLeft ) + nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ( ::aReport[ PAGEX ] - ::M2X( ::nPdfLeft ) * 2 - 9.0 ) / 100.00
      nHeight := ::aReport[ PAGEY ] - ::R2D( nHeight )
      nWidth  := ::M2X( ::nPdfLeft ) + nWidth * 100.00 / ::aReport[ REPORTWIDTH ] * ( ::aReport[ PAGEX ] - ::M2X( ::nPdfLeft ) * 2 - 9.0 ) / 100.00
   ENDIF

   AAdd( ::aPageImages, { cFile, nRow, nCol, nHeight, nWidth } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Length( cString, cUnits ) CLASS TPDF

   LOCAL nWidth := 0.00, nI, nLen, nArr, nAdd := ( ::nFontName - 1 ) % 4

   DEFAULT cUnits TO "M"

   IF Right( cString, 1 ) == Chr( 255 ) //reverse
      cString := Left( cString, Len( cString ) - 1 )
   ELSEIF Right( cString, 1 ) == Chr( 254 ) //underline
      cString := Left( cString, Len( cString ) - 1 )
   ENDIF
   IF ( nI := At( Chr( 253 ), cString ) ) > 0 // some color text inside
      cString := Stuff( cString, nI, 4, "" )
   ENDIF

   nLen := Len( cString )

   IF cUnits == "R"
      RETURN nLen
   ENDIF

   IF ::GetFontInfo( "NAME" ) == "Times"
      nArr := 1
   ELSEIF ::GetFontInfo( "NAME" ) == "Helvetica"
      nArr := 2
   ELSE
      nArr := 3
   ENDIF

   FOR nI := 1 TO nLen
      nWidth += ::aFontWidth[ nArr, ( Asc( SubStr( cString, nI, 1 ) ) - 32 ) * 4 + 1 + nAdd ] * 25.4 * ::nFontSize / 720.00 / 100.00
   NEXT

   IF cUnits == "M"
      RETURN nWidth
   ENDIF

   RETURN ::M2X( nWidth )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NewLine( n ) CLASS TPDF

   DEFAULT n TO 1
   IF ::aReport[ REPORTLINE ] + n + ::nPdfTop > ::nPdfBottom
      ::NewPage()
      ::aReport[ REPORTLINE ] += 1
   ELSE
      ::aReport[ REPORTLINE ] += n
   ENDIF

   RETURN ::aReport[ REPORTLINE ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NewPage( cPageSize, cPageOrient, nLpi, cFontName, nFontType, nFontSize ) CLASS TPDF

   DEFAULT cPageSize   TO ::aReport[ PAGESIZE ]
   DEFAULT cPageOrient TO ::aReport[ PAGEORIENT ]
   DEFAULT nLpi        TO ::aReport[ LPI ]
   DEFAULT cFontName   TO ::GetFontInfo( "NAME" )
   DEFAULT nFontType   TO ::GetFontInfo( "TYPE" )
   DEFAULT nFontSize   TO ::nFontSize

   IF ::lIsPageActive
      ::ClosePage()
   ENDIF

   ::lIsPageActive := .T.

   ::aPageFonts  := {}
   ::aPageImages := {}

   ++ ::aReport[ REPORTPAGE ]

   ::PageSize( cPageSize )
   ::PageOrient( cPageOrient )
   ::SetLPI( nLpi )

   ::SetFont( cFontName, nFontType, nFontSize )

   ::DrawHeader()

   ::aReport[ REPORTLINE ] := 0

   ::nFontNamePrev := 0
   ::nFontSizePrev := 0

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PageSize( cPageSize ) CLASS TPDF

   LOCAL nSize, aSize := { { "LETTER",     8.50, 11.00 }, ;
                           { "LEGAL",      8.50, 14.00 }, ;
                           { "LEDGER",    11.00, 17.00 }, ;
                           { "EXECUTIVE",  7.25, 10.50 }, ;
                           { "A4",         8.27, 11.69 }, ;
                           { "A3",        11.69, 16.54 }, ;
                           { "JIS B4",    10.12, 14.33 }, ;
                           { "JIS B5",     7.16, 10.12 }, ;
                           { "JPOST",      3.94,  5.83 }, ;
                           { "JPOSTD",     5.83,  7.87 }, ;
                           { "COM10",      4.12,  9.50 }, ;
                           { "MONARCH",    3.87,  7.50 }, ;
                           { "C5",         6.38,  9.01 }, ;
                           { "DL",         4.33,  8.66 }, ;
                           { "B5",         6.93,  9.84 }, ;
                           { "USSTDFOLD", 14.87, 11.00 } }

   DEFAULT cPageSize TO "LETTER"

   nSize := AScan( aSize, { |arr| arr[ 1 ] == cPageSize } )
   IF nSize == 0
      nSize := 1
   ENDIF

   ::aReport[ PAGESIZE ] := aSize[ nSize, 1 ]
   IF ::aReport[ PAGEORIENT ] == "P"
      ::aReport[ PAGEX ] := aSize[ nSize, 2 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize, 3 ] * 72
   ELSE
      ::aReport[ PAGEX ] := aSize[ nSize, 3 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize, 2 ] * 72
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PageOrient( cPageOrient ) CLASS TPDF

   DEFAULT cPageOrient TO "P"

   ::aReport[ PAGEORIENT ] := cPageOrient
   ::PageSize( ::aReport[ PAGESIZE ] )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PageNumber( n ) CLASS TPDF

   DEFAULT n TO 0
   IF n > 0
      ::aReport[ REPORTPAGE ] := n 
   ENDIF

   RETURN ::aReport[ REPORTPAGE ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Reverse( cString ) CLASS TPDF

   IF Right( cString, 1 ) # Chr( 255 )
      IF Right( cString, 1 ) == Chr( 254 )
         cString := Left( cString, Len( cString ) - 1 )
      ENDIF
      cString += Chr( 255 )
   ENDIF

   RETURN cString

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RJust( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPDF

   LOCAL nLen, nAt

   DEFAULT nRow   TO ::aReport[ REPORTLINE ]
   DEFAULT cUnits TO "R"
   DEFAULT lExact TO .F.
   DEFAULT nCol   TO iif( cUnits == "R", ::aReport[ REPORTWIDTH ], iif( cUnits == "M", ::X2M( ::aReport[ PAGEX ] ), ::aReport[ PAGEX ] ) )

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFRJUST", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := At( "#pagenumber#", cString ) ) > 0
      cString := Left( cString, nAt - 1 ) + LTrim( Str( ::PageNumber() ) ) + SubStr( cString, nAt + 12 )
   ENDIF

   nLen := ::Length( cString, cUnits )

   ::AtSay( cString, nRow, nCol - nLen, cUnits, lExact )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFont, nType, nSize, cId ) CLASS TPDF

   DEFAULT cFont TO "Times"
   DEFAULT nType TO 0
   DEFAULT nSize TO 10

   IF ::aReport[ HEADEREDIT ]
      RETURN ::Header( "PDFSETFONT", cId, { cFont, nType, nSize } )
   ENDIF

   cFont := Upper( cFont )
   ::nFontSize := nSize

   IF cFont == "TIMES"
      ::nFontName := nType + 1
   ELSEIF cFont == "HELVETICA"
      ::nFontName := nType + 5
   ELSE
      ::nFontName := nType + 9
   ENDIF

   AAdd( ::aPageFonts, ::nFontName )

   IF AScan( ::aFonts, { |arr| arr[ 1 ] == ::nFontName } ) == 0
      AAdd( ::aFonts, { ::nFontName, ++ ::nNextObj } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetLPI( nLpi ) CLASS TPDF

   LOCAL cLpi := AllTrim( Str( nLpi ) )

   DEFAULT nLpi TO 6

   cLpi := iif( cLpi $ "1;2;3;4;6;8;12;16;24;48", cLpi, "6" )
   ::aReport[ LPI ] := Val( cLpi )

   ::PageSize( ::aReport[ PAGESIZE ] )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD StringB( cString ) CLASS TPDF

   cString := StrTran( cString, "(", "\(" )
   cString := StrTran( cString, ")", "\)" )

   RETURN cString

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits ) CLASS TPDF

   RETURN ::Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, "", .F. )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint ) CLASS TPDF
/*
 * cString must contain printable chars only, thus Chr(255), Chr(254) and Chr(253)+Color are printed.
 * the only exception is when cString contains only one token.
 */

   LOCAL cDelim := Chr( 0 ) + Chr( 9 ) + Chr( 10 ) + Chr( 13 ) + Chr( 26 ) + Chr( 32 ) + Chr( 138 ) + Chr( 141 )
   LOCAL nI, cTemp, cToken, k, nL, nRow, nLines, nLineLen, nStart
   LOCAL lParagraph, nSpace, nNew, nTokenLen, nCRLF, nTokens, nLen

   DEFAULT nTab TO -1
   DEFAULT cUnits   TO "R"
   DEFAULT nJustify TO 4
   DEFAULT lPrint   TO .T.
   DEFAULT cColor   TO ""

   IF cUnits == "M"
      nTop := ::M2R( nTop )
   ELSEIF cUnits == "R"
      nLeft := ::X2M( ::M2X( ::nPdfLeft ) +  nLeft * 100.00 / ::aReport[ REPORTWIDTH ] * ( ::aReport[ PAGEX ] - ::M2X( ::nPdfLeft ) * 2 - 9.0 ) / 100.00 )
   ENDIF

   ::aReport[ REPORTLINE ] := nTop - 1

   nSpace  := ::Length( " " )
   nLines  := 0
   nCRLF   := 0
   nNew    := nTab
   cString := AllTrim( cString )
   nTokens := TPDF_NumToken( cString, cDelim )
   nStart  := 1

   IF nJustify == 2                      // center
      nLeft := nLeft - nLength / 2
   ELSEIF nJustify == 3                  // right
      nLeft := nLeft - nLength
   ENDIF

   nL := nLeft
   nL += nNew * nSpace // first always paragraph
   nLineLen := nSpace * nNew - nSpace

   lParagraph := .T.
   nI := 1

   DO WHILE nI <= nTokens
      cToken := TPDF_Token( cString, cDelim, nI )
      nTokenLen := ::Length( cToken )
      nLen := len( cToken )

      IF nLineLen + nSpace + nTokenLen > nLength
         IF nStart == nI // single word > nLength
            k := 1
            DO WHILE k <= nLen
               cTemp := ""
               nLineLen := 0.00
               nL := nLeft
               IF lParagraph
                  nLineLen += nSpace * nNew
                  IF nJustify # 2
                     nL += nSpace * nNew
                  ENDIF
                  lParagraph := .F.
               ENDIF
               IF nJustify == 2
                  nL := nLeft + ( nLength - ::Length( cTemp ) ) / 2
               ELSEIF nJustify == 3
                  nL := nLeft + nLength - ::Length( cTemp )
               ENDIF
               DO WHILE k <= nLen .AND. ( ( nLineLen += ::Length( SubStr( cToken, k, 1 ) ) ) <= nLength )
                  nLineLen += ::Length( SubStr( cToken, k, 1 ) )
                  cTemp += SubStr( cToken, k, 1 )
                  ++ k
               enddo
               IF Empty( cTemp ) // single character > nlength
                  cTemp := SubStr( cToken, k, 1 )
                  ++ k
               ENDIF
               ++ nLines
               IF lPrint
                  nRow := ::NewLine( 1 )
                  ::AtSay( cColor + cTemp, ::R2M( nRow + ::nPdfTop ), nL, "M" )
               ENDIF
            ENDDO
            ++ nI
            nStart := nI
         ELSE
            ::TextPrint( nI - 1, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ENDIF
      ELSEIF ( nI == nTokens ) .OR. ( nI < nTokens .AND. ( nCRLF := ::TextNextPara( cString, cDelim, nI ) ) > 0 )
         IF nI == nTokens
            nLineLen += nSpace + nTokenLen
         ENDIF
         ::TextPrint( nI, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ++ nI

         IF nCRLF > 1
            nLines += nCRLF - 1
         ENDIF
         IF lPrint
            ::NewLine( nCRLF - 1 )
         ENDIF
      ELSE
         nLineLen += nSpace + nTokenLen
         ++ nI
      ENDIF
   ENDDO

   RETURN nLines

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD UnderLine( cString ) CLASS TPDF

   IF Right( cString, 1 ) # Chr( 254 )
      IF Right( cString, 1 ) == Chr( 255 )
         cString := Left( cString, Len( cString ) - 1 )
      ENDIF
      cString += Chr( 254 )
   ENDIF

   RETURN cString

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OpenHeader( cFile ) CLASS TPDF

   LOCAL nAt

   DEFAULT cFile TO ""

   IF ! Empty( cFile )
      cFile := AllTrim( cFile )
      IF ( Len( cFile ) > 12 .OR. ;
           At( " ", cFile ) > 0 .OR. ;
           ( At( " ", cFile ) == 0 .AND. Len( cFile ) > 8 ) .OR. ;
           ( ( nAt := At( ".", cFile ) ) > 0 .AND. Len( SubStr( cFile, nAt + 1 ) ) > 3 ) )
         COPY File ( cFile ) TO temp.tmp
         cFile := "temp.tmp"
      ENDIF
      ::aHeader := TPDF_File2Array( cFile )
   ELSE
      ::aHeader := {}
   ENDIF
   ::aReport[ MARGINS ] := .T.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EditOnHeader() CLASS TPDF

   ::aReport[ HEADEREDIT ] := .T.
   ::aReport[ MARGINS ] := .T.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EditOffHeader() CLASS TPDF

   ::aReport[ HEADEREDIT ] := .F.
   ::aReport[ MARGINS ] := .T.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CloseHeader() CLASS TPDF

   ::aHeader := {}
   ::aReport[ MARGINS ] := .F.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteHeader( cId ) CLASS TPDF

   LOCAL nRet := -1, nId

   cId := Upper( cId )
   nId := AScan( ::aHeader, { |arr| arr[ 3 ] == cId } )
   IF nId > 0
      nRet := Len( ::aHeader ) - 1
      ADel( ::aHeader, nId )
      ASize( ::aHeader, nRet )
      ::aReport[ MARGINS ] := .T.
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EnableHeader( cId ) CLASS TPDF

   LOCAL nId

   cId := Upper( cId )
   nId := AScan( ::aHeader, { |arr| arr[ 3 ] == cId } )
   IF nId > 0
      ::aHeader[ nId, 1 ] := .T.
      ::aReport[ MARGINS ] := .T.
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DisableHeader( cId ) CLASS TPDF

   LOCAL nId

   cId := Upper( cId )
   nId := AScan( ::aHeader, { |arr| arr[ 3 ] == cId } )
   IF nId > 0
      ::aHeader[ nId, 1 ] := .F.
      ::aReport[ MARGINS ] := .T.
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveHeader( cFile ) CLASS TPDF

   TPDF_Array2File( "temp.tmp", ::aHeader )
   COPY file temp.tmp to ( cFile )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Header( cFunction, cId, arr ) CLASS TPDF

   LOCAL nId, nI, nLen, nIdLen

   nId := 0
   IF ! Empty( cId )
      cId := Upper( cId )
      nId := AScan( ::aHeader, { |arr| arr[ 3 ] == cId } )
   ENDIF
   IF nId == 0
      nLen := Len( ::aHeader )
      IF Empty( cId )
         cId := cFunction
         nIdLen := Len( cId )
         FOR nI := 1 TO nLen
            IF ::aHeader[ nI, 2 ] == cId
               IF Val( SubStr( ::aHeader[ nI, 3 ], nIdLen + 1 ) ) > nId
                  nId := Val( SubStr( ::aHeader[ nI, 3 ], nIdLen + 1 ) )
               ENDIF
            ENDIF
         NEXT
         ++ nId
         cId += LTrim( Str( nId ) )
      ENDIF
      AAdd( ::aHeader, { .T., cFunction, cId } )
      ++ nLen
      FOR nI := 1 TO Len( arr )
         AAdd( ::aHeader[ nLen ], arr[ nI ] )
      NEXT
   ELSE
      ASize( ::aHeader[ nId ], 3 )
      FOR nI := 1 TO Len( arr )
         AAdd( ::aHeader[ nId ], arr[ nI ] )
      NEXT
   ENDIF

   RETURN cId

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DrawHeader() CLASS TPDF

   LOCAL nI, nFont, nSize, nLen := Len( ::aHeader )

   IF nLen > 0
      // save font
      nFont := ::nFontName
      nSize := ::nFontSize
      FOR nI := 1 TO nLen
         IF ::aHeader[ nI, 1 ]   // enabled
            DO CASE
            CASE ::aHeader[ nI, 2 ] == "PDFATSAY"
               ::AtSay( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 7 ], ::aHeader[ nI, 8 ], ::aHeader[ nI, 3 ] )
            CASE ::aHeader[ nI, 2 ] == "PDFCENTER"
               ::Center( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 7 ], ::aHeader[ nI, 8 ], ::aHeader[ nI, 3 ] )
            CASE ::aHeader[ nI, 2 ] == "PDFRJUST"
               ::RJust( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 7 ], ::aHeader[ nI, 8 ], ::aHeader[ nI, 3 ] )
            CASE ::aHeader[ nI, 2 ] == "PDFBOX"
               ::Box( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 7 ], ::aHeader[ nI, 8 ], ::aHeader[ nI, 9 ], ::aHeader[ nI, 10 ], ::aHeader[ nI, 3 ] )
            CASE ::aHeader[ nI, 2 ] == "PDFSETFONT"
               ::SetFont( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 3 ] )
            CASE ::aHeader[ nI, 2 ] == "PDFIMAGE"
               ::Image( ::aHeader[ nI, 4 ], ::aHeader[ nI, 5 ], ::aHeader[ nI, 6 ], ::aHeader[ nI, 7 ], ::aHeader[ nI, 8 ], ::aHeader[ nI, 9 ], ::aHeader[ nI, 3 ] )
            ENDCASE
         ENDIF
      NEXT
      ::nFontName := nFont
      ::nFontSize := nSize
      IF ::aReport[ MARGINS ]
         ::Margins()
      ENDIF
   ELSE
      IF ::aReport[ MARGINS ]
         ::nPdfTop    := 1    // top
         ::nPdfLeft   := 10   // left & right in mm
         ::nPdfBottom := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1    // bottom row, default "LETTER", "P", 6
         ::aReport[ MARGINS ] := .F.
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Margins( nTop, nLeft, nBottom ) CLASS TPDF

   LOCAL nI, nLen := Len( ::aHeader ), nTemp, aTemp, nHeight

   DEFAULT nTop  TO 1
   DEFAULT nLeft TO 10
   DEFAULT nBottom TO ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1   // bottom row, default "LETTER", "P", 6

   ::nPdfTop    := nTop
   ::nPdfLeft   := nLeft
   ::nPdfBottom := nBottom

   FOR nI := 1 TO nLen
      IF ::aHeader[ nI, 1 ]   // enabled
         IF ::aHeader[ nI, 2 ] == "PDFSETFONT"
         ELSEIF ::aHeader[ nI, 2 ] == "PDFIMAGE"
            IF ::aHeader[ nI, 8 ] == 0   // picture in header, first at all, not at any page yet
               aTemp := ::ImageInfo( ::aHeader[ nI, 4 ] )
               IF Len( aTemp ) # 0
                  nHeight := aTemp[ IMAGE_HEIGHT ] / aTemp[ IMAGE_YRES ] * 25.4
                  IF ::aHeader[ nI, 7 ] == "D"
                     nHeight := ::M2X( nHeight )
                  ENDIF
               ELSE
                  nHeight := ::aHeader[ nI, 8 ]
               ENDIF
            ELSE
               nHeight := ::aHeader[ nI, 8 ]
            ENDIF
            IF ::aHeader[ nI, 7 ] == "M"
               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2
               IF ::aHeader[ nI, 5 ] < nTemp
                  nTemp := ( ::aHeader[ nI, 5 ] + nHeight ) * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aHeader[ nI, 5 ] * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aHeader[ nI, 7 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2
               IF ::aHeader[ nI, 5 ] < nTemp
                  nTemp := ( ::aHeader[ nI, 5 ] + nHeight ) * ::aReport[ LPI ] / 72   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aHeader[ nI, 5 ] * ::aReport[ LPI ] / 72   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF ::aHeader[ nI, 2 ] == "PDFBOX"
            IF ::aHeader[ nI, 10 ] == "M"
               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2
               IF ::aHeader[ nI, 4 ] < nTemp .AND. ;
                  ::aHeader[ nI, 6 ] < nTemp
                  nTemp := ::aHeader[ nI, 6 ] * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ELSEIF ::aHeader[ nI, 4 ] < nTemp .AND. ;
                  ::aHeader[ nI, 6 ] > nTemp
                  nTemp := ( ::aHeader[ nI, 4 ] + ::aHeader[ nI, 8 ] ) * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
                  nTemp := ( ::aHeader[ nI, 6 ] - ::aHeader[ nI, 8 ] ) * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ELSEIF ::aHeader[ nI, 4 ] > nTemp .AND. ;
                  ::aHeader[ nI, 6 ] > nTemp
                  nTemp := ::aHeader[ nI, 4 ] * ::aReport[ LPI ] / 25.4   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aHeader[ nI, 10 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2
               IF ::aHeader[ nI, 4 ] < nTemp .AND. ;
                  ::aHeader[ nI, 6 ] < nTemp
                  nTemp := ::aHeader[ nI, 6 ] / ::aReport[ LPI ]   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ELSEIF ::aHeader[ nI, 4 ] < nTemp .AND. ;
                  ::aHeader[ nI, 6 ] > nTemp
                  nTemp := ( ::aHeader[ nI, 4 ] + ::aHeader[ nI, 8 ] ) / ::aReport[ LPI ]   // top
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
                  nTemp := ( ::aHeader[ nI, 6 ] - ::aHeader[ nI, 8 ] ) / ::aReport[ LPI ]   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ELSEIF ::aHeader[ nI, 4 ] > nTemp .AND. ;
                  ::aHeader[ nI, 6 ] > nTemp
                  nTemp := ::aHeader[ nI, 4 ] / ::aReport[ LPI ]   // top
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            IF ::aHeader[ nI, 7 ] == "R"
               nTemp := ::aHeader[ nI, 5 ]   // top
               IF ::aHeader[ nI, 5 ] > ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] / 2
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aHeader[ nI, 7 ] == "M"
               nTemp := ::aHeader[ nI, 5 ] * ::aReport[ LPI ] / 25.4   // top
               IF ::aHeader[ nI, 5 ] > ::aReport[ PAGEY ] / 72 * 25.4 / 2
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::nPdfTop
                     ::nPdfTop := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aHeader[ nI, 7 ] == "D"
               nTemp := ::aHeader[ nI, 5 ] / ::aReport[ LPI ]   // top
               IF ::aHeader[ nI, 5 ] > ::aReport[ PAGEY ] / 2
                  IF nTemp < ::nPdfBottom
                     ::nPdfBottom := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::nPdfTop
                    ::nPdfTop := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT

   ::aReport[ MARGINS ] := .F.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CreateHeader( file, size, orient, lpi, width ) CLASS TPDF

   LOCAL aReportStyle := { { 1,     2,   3,   4,    5,     6    }, ;   // "Default"
                           { 2.475, 4.0, 4.9, 6.4,  7.5,  64.0  }, ;   // "P6"
                           { 3.3,   5.4, 6.5, 8.6, 10.0,  85.35 }, ;   // "P8"
                           { 2.475, 4.0, 4.9, 6.4,  7.5,  48.9  }, ;   // "L6"
                           { 3.3,   5.4, 6.5, 8.6, 10.0,  65.2  }, ;   // "L8"
                           { 2.475, 4.0, 4.9, 6.4,  7.5,  82.0  }, ;   // "P6"
                           { 3.3,   5.4, 6.5, 8.6, 10.0, 109.35 }  ;   // "P8"
                         }
   LOCAL nStyle := 1, nAdd := 0.00

   DEFAULT size   TO ::aReport[ PAGESIZE ]
   DEFAULT orient TO ::aReport[ PAGEORIENT ]
   DEFAULT lpi    TO ::aReport[ LPI ]
   DEFAULT width  TO 200

   IF size == "LETTER"
      IF orient == "P"
         IF lpi == 6
            nStyle := 2
         ELSEIF lpi == 8
            nStyle := 3
         ENDIF
      ELSEIF orient == "L"
         IF lpi == 6
            nStyle := 4
         ELSEIF lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ELSEIF size == "LEGAL"
      IF orient == "P"
         IF lpi == 6
            nStyle := 6
         ELSEIF lpi == 8
            nStyle := 7
         ENDIF
      ELSEIF orient == "L"
         IF lpi == 6
            nStyle := 4
         ELSEIF lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ENDIF

   ::EditOnHeader()

   IF size == "LEGAL"
      nAdd := 76.2
   ENDIF

   IF orient == "P"
      ::Box(  5.0, 5.0, 274.0 + nAdd, 210.0, 1.0 )
      ::Box(  6.5, 6.5, 272.5 + nAdd, 208.5, 0.5 )

      ::Box( 11.5, 9.5,  22.0,        205.5,  0.5, 5 )
      ::Box( 23.0, 9.5,  33.5,        205.5,  0.5, 5 )
      ::Box( 34.5, 9.5, 267.5 + nAdd, 205.5,  0.5 )
   ELSE
      ::Box(  5.0, 5.0, 210.0, 274.0 + nAdd, 1.0 )
      ::Box(  6.5, 6.5, 208.5, 272.5 + nAdd, 0.5 )

      ::Box( 11.5, 9.5,  22.0, 269.5 + nAdd, 0.5, 5 )
      ::Box( 23.0, 9.5,  33.5, 269.5 + nAdd, 0.5, 5 )
      ::Box( 34.5, 9.5, 203.5, 269.5 + nAdd, 0.5 )
   ENDIF

   ::SetFont( "Arial", 1, 10 )
   ::AtSay( "Test Line 1", aReportStyle[ nStyle, 1 ], 1, "R", .T. )

   ::SetFont( "Times", 1, 18 )
   ::Center( "Test Line 2", aReportStyle[ nStyle, 2 ], NIL, "R", .T. )

   ::SetFont( "Times", 1, 12 )
   ::Center( "Test Line 3", aReportStyle[ nStyle, 3 ], NIL, "R", .T. )

   ::SetFont( "Arial", 1, 10 )
   ::AtSay( "Test Line 4", aReportStyle[ nStyle, 4 ], 1, "R", .T. )

   ::SetFont( "Arial", 1, 10 )
   ::AtSay( "Test Line 5", aReportStyle[ nStyle, 5 ], 1, "R", .T. )

   ::AtSay( DToC( Date() ) + " " + TPDF_TimeAsAMPM( Time() ), aReportStyle[ nStyle, 6 ], 1, "R", .T. )
   ::RJust( "Page: #pagenumber#", aReportStyle[ nStyle, 6 ], ::aReport[ REPORTWIDTH ], "R", .T. )

   ::EditOffHeader()
   ::SaveHeader( file )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ImageInfo( cFile ) CLASS TPDF

   LOCAL cTemp := Upper( SubStr( cFile, RAt( ".", cFile ) + 1 ) ), aTemp := {}

   // TODO: Load from resource

   DO CASE
   CASE ! File( cFile )
      aTemp := {}
   CASE cTemp == "TIF" .OR. cTemp == "TIFF"
      aTemp := ::TIFFInfo( cFile )
   CASE cTemp == "JPG" .OR. cTemp == "JPEG"
      aTemp := ::JPEGInfo( cFile )
   CASE cTemp == "BMP"
      aTemp := ::BMPInfo( cFile )
   ENDCASE

   RETURN aTemp

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TIFFInfo( cFile ) CLASS TPDF

   LOCAL c40 := Chr( 0 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 )
   LOCAL aCount := { 1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8 }
   LOCAL nHandle, cValues, c2, nFieldType, nCount, nPos, nTag, nValues
   LOCAL nOffset, cTemp, cIFDNEXT, nIFD, nFields, nn, nPhoto := -1, nResolU := 0
   LOCAL nWidth := 0, nHeight := 0, nBits := 1, nFrom := 0, nLength := 0, xRes := 0, yRes := 0, aTemp := {}

   nHandle := FOpen( cFile )

   c2 := Space( 2 )
   FRead( nHandle, @c2, 2 )
   FRead( nHandle, @c2, 2 )

   cIFDNEXT := Space( 4 )
   FRead( nHandle, @cIFDNEXT, 4 )

   cTemp := Space( 12 )

   DO WHILE ! ( cIFDNEXT == c40 )               // read IFD's

      nIFD := Bin2L( cIFDNEXT )

      FSeek( nHandle, nIFD )

      FRead( nHandle, @c2, 2 )
      nFields := Bin2I( c2 )

      FOR nn := 1 TO nFields
         FRead( nHandle, @cTemp, 12 )

         nTag   := Bin2W( SubStr( cTemp, 1, 2 ) )
         nFieldType := Bin2W( SubStr( cTemp, 3, 2 ) )
         /*
         1 = BYTE       8-bit unsigned integer.
         2 = ASCII      8-bit byte that contains a 7-bit ASCII code; the last byte
                        must be NUL (binary zero).
         3 = SHORT      16-bit (2-byte) unsigned integer.
         4 = LONG       32-bit (4-byte) unsigned integer.
         5 = RATIONAL   Two LONGs: the first represents the numerator of a
                        fraction; the second, the denominator.
         In TIFF 6.0, some new field types have been defined:
         6 = SBYTE      An 8-bit signed (twos-complement) integer.
         7 = UNDEFINED  An 8-bit byte that may contain anything, depending on
                        the definition of the field.
         8 = SSHORT     A 16-bit (2-byte) signed (twos-complement) integer.
         9 = SLONG      A 32-bit (4-byte) signed (twos-complement) integer.
         10 = SRATIONAL Two SLONG's: the first represents the numerator of a
                        fraction, the second the denominator.
         11 = FLOAT     Single precision (4-byte) IEEE format.
         12 = DOUBLE    Double precision (8-byte) IEEE format.
         */
         nCount := Bin2L( SubStr( cTemp, 5, 4 ) )
         nOffset:= Bin2L( SubStr( cTemp, 9, 4 ) )

         IF nCount > 1 .OR. nFieldType == RATIONAL .OR. nFieldType == SRATIONAL
            nPos := FSeek( nHandle, 0, FS_RELATIVE )
            FSeek( nHandle, nOffset)

            nValues := nCount * aCount[ nFieldType ]
            cValues := Space( nValues )
            FRead( nHandle, @cValues, nValues )
            FSeek( nHandle, nPos )
         ELSE
            cValues := SubStr( cTemp, 9, 4 )
         ENDIF

         IF nFieldType ==  ASCII
            -- nCount
         ENDIF
         // cTag := ""
         DO CASE
         CASE nTag == 256
            /*
            cTag := "ImageWidth"
            The number of columns in the image, i.e., the number of pixels per scanline.
            */
            IF nFieldType ==  SHORT
               nWidth := Bin2W( SubStr( cValues, 1, 2 ) )
            ELSEIF nFieldType ==  LONG
               nWidth := Bin2L( SubStr( cValues, 1, 4 ) )
            ENDIF

         CASE nTag == 257
            /*
            cTag := "ImageLength"
            The number of rows (sometimes described as scanlines) in the image.
            */
            IF nFieldType ==  SHORT
               nHeight := Bin2W( SubStr( cValues, 1, 2 ) )
            ELSEIF nFieldType ==  LONG
               nHeight := Bin2L( SubStr( cValues, 1, 4 ) )
            ENDIF

         CASE nTag == 258
            /*
            cTag := "BitsPerSample"
            The number of bits per component.
            Allowable values for Baseline TIFF grayscale images are 4 and 8, allowing either
            16 or 256 distinct shades of gray.
            */
            IF nFieldType == SHORT
               nBits := Bin2W( cValues )
            ENDIF

         CASE nTag == 259
            /*
            cTag := "Compression"
            Values:
            1 = No compression, but pack data into bytes as tightly as possible, leaving no unused
            bits (except at the end of a row). The component values are stored as an array of
            type BYTE. Each scan line (row) is padded to the next BYTE boundary.
            2 = CCITT Group 3 1-Dimensional Modified Huffman run length encoding. See
            Section 10 for a description of Modified Huffman Compression.
            32773 = PackBits compression, a simple byte-oriented run length scheme. See the
            PackBits section for details.
            Data compression applies only to raster image data. All other TIFF fields are
            unaffected.
            Baseline TIFF readers must handle all three compression schemes.
            */
            // nTemp := 0
            // IF nFieldType == SHORT
            //    nTemp := Bin2W( cValues )
            // ENDIF

         CASE nTag == 262
            /*
            cTag := "PhotometricInterpretation"
            PhotometricInterpretation
            Tag = 262 (106.H)
            Type = SHORT
            Values:
            0 = WhiteIsZero. For bilevel and grayscale images: 0 is imaged as white. The maximum
            value is imaged as black. This is the normal value for Compression=2.
            1 = BlackIsZero. For bilevel and grayscale images: 0 is imaged as black. The maximum
            value is imaged as white. If this value is specified for Compression=2, the
            image should display and print reversed.
            */
            IF nFieldType == SHORT
               nPhoto := Bin2W( cValues )
            ENDIF
            HB_SYMBOL_UNUSED( nPhoto )

         CASE nTag == 264
            /*
            cTag := "CellWidth"
            The width of the dithering or halftoning matrix used to create a dithered or
            halftoned bilevel file.
            Type = SHORT
            N = 1
            No default. See also Threshholding.
            */

         CASE nTag == 265
            /*
            cTag := "CellLength"
            The length of the dithering or halftoning matrix used to create a dithered or
            halftoned bilevel file.
            Type = SHORT
            N = 1
            This field should only be present if Threshholding = 2
            No default. See also Threshholding.
            */

         CASE nTag == 266
            /*
            cTag := "FillOrder"
            The logical order of bits within a byte.
            Type = SHORT
            N = 1
            */

         CASE nTag == 273
            /*
            cTag := "StripOffsets"
            Type = SHORT or LONG
            For each strip, the byte offset of that strip.
            */
            IF nFieldType ==  SHORT
               nFrom := Bin2W( SubStr( cValues, 1, 2 ) )
            ELSEIF nFieldType ==  LONG
               nFrom := Bin2L( SubStr( cValues, 1, 4 ) )
            ENDIF

         CASE nTag == 277
            /*
            cTag := "SamplesPerPixel"
            Type = SHORT
            The number of components per pixel. This number is 3 for RGB images, unless
            extra samples are present. See the ExtraSamples field for further information.
            */

         CASE nTag == 278
            /*
            cTag := "RowsPerStrip"
            Type = SHORT or LONG
            The number of rows in each strip (except possibly the last strip.)
            For example, if ImageLength is 24, and RowsPerStrip is 10, then there are 3
            strips, with 10 rows in the first strip, 10 rows in the second strip, and 4 rows in the
            third strip. The data in the last strip is not padded with 6 extra rows of dummy data.
            */

         CASE nTag == 279
            /*
            cTag := "StripByteCounts"
            Type = SHORT or LONG
            For each strip, the number of bytes in that strip after any compression.
            */
            IF nFieldType ==  SHORT
               nLength := Bin2W( SubStr( cValues, 1, 2 ) )
            ELSEIF nFieldType ==  LONG
               nLength := Bin2L( SubStr( cValues, 1, 4 ) )
            ENDIF
            nLength *= nCount // Count all strips !!!

         CASE nTag == 282
            /*
            cTag := "XResolution"
            Type = RATIONAL
            The number of pixels per ResolutionUnit in the ImageWidth (typically, horizontal
            - see Orientation) direction.
            */
            xRes := Bin2L( SubStr( cValues, 1, 4 ) )

         CASE nTag == 283
            /*
            cTag := "YResolution"
            Type = RATIONAL
            The number of pixels per ResolutionUnit in the ImageLength (typically, vertical)
            direction.
            */
            yRes := Bin2L( SubStr( cValues, 1, 4 ) )

         CASE nTag == 284
            /*
            cTag := "PlanarConfiguration"
            Type = SHORT
            */

         CASE nTag == 288
            /*
            cTag := "FreeOffsets"
            For each string of contiguous unused bytes in a TIFF file, the byte offset of the
            string.
            Type = LONG
            Not recommended for general interchange.
            See also FreeByteCounts.
            */

         CASE nTag == 289
            /*
            cTag := "FreeByteCounts"
            For each string of contiguous unused bytes in a TIFF file, the number of bytes in
            the string.
            Type = LONG
            Not recommended for general interchange.
            See also FreeOffsets.
            */

         CASE nTag == 296
            /*
            cTag := "ResolutionUnit"
            Type = SHORT
            Values:
            1 = No absolute unit of measurement. Used for images that may have a non-square
            aspect ratio but no meaningful absolute dimensions.
            2 = Inch.
            3 = Centimeter.
            Default = 2 (inch).
            */
            IF nFieldType == SHORT
               nResolU := Bin2W( cValues )
            ENDIF
            HB_SYMBOL_UNUSED( nResolU )

         CASE nTag == 305
            /*
            cTag := "Software"
            Type = ASCII
            */
         CASE nTag == 306
            /*
            cTag := "DateTime"
            Date and time of image creation.
            Type = ASCII
            N = 2 0
            The format is: YYYY:MM:DD HH:MM:SS, with hours like those on a 24-hour
            clock, and one space character between the date and the time. The length of the
            string, including the terminating NUL, is 20 bytes.
            */

         CASE nTag == 315
            /*
            cTag := "Artist"
            Person who created the image.
            Type = ASCII
            Note: some older TIFF files used this tag for storing Copyright information.
            */

         CASE nTag == 320
            /*
            cTag := "ColorMap"
            Type = SHORT
            N = 3 * ( 2** BitsPerSample )
            This field defines a Red-Green-Blue color map (often called a lookup table) for
            palette color images. In a palette-color image, a pixel value is used to index into an
            RGB-lookup table. For example, a palette-color pixel having a value of 0 would
            be displayed according to the 0th Red, Green, Blue triplet.
            In a TIFF ColorMap, all the Red values come first, followed by the Green values,
            then the Blue values. In the ColorMap, black is represented by 0,0,0 and white is
            represented by 65535, 65535, 65535.
            */

         CASE nTag == 338
            /*
            cTag := "ExtraSamples"
            Description of extra components.
            Type = SHORT
            N = m
            */

         CASE nTag == 33432
            /*
            cTag := "Copyright"
            Copyright notice.
            Type = ASCII
            Copyright notice of the person or organization that claims the copyright to the
            image. The complete copyright statement should be listed in this field including
            any dates and statements of claims. For example, Copyright, John Smith, 19xx.
            All rights reserved.
            */

         OTHERWISE
            /*
            cTag := "Unknown"
            */

         ENDCASE
      NEXT
      FRead( nHandle, @cIFDNEXT, 4 )
   ENDDO

   FClose( nHandle )

   AAdd( aTemp, nWidth )
   AAdd( aTemp, nHeight )
   AAdd( aTemp, xRes )
   AAdd( aTemp, yRes )
   AAdd( aTemp, nBits )
   AAdd( aTemp, nFrom )
   AAdd( aTemp, nLength )
   AAdd( aTemp, 1 )
   AAdd( aTemp, NIL )

   RETURN aTemp

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD JPEGInfo( cFile ) CLASS TPDF

   LOCAL nBuffer := 1024, cBuffer := Space( nBuffer ), nAt, nHandle
   LOCAL nWidth, nHeight, nBits := 8, nFrom := 0
   LOCAL nLength, xRes, yRes, aTemp := {}

   nHandle := FOpen( cFile )
   FRead( nHandle, @cBuffer, nBuffer )
   nLength := FSeek( nHandle, 0, FS_END )
   FClose( nHandle )

   xRes := Asc( SubStr( cBuffer, 15, 1 ) ) * 256 + Asc( SubStr( cBuffer, 16, 1 ) )
   yRes := Asc( SubStr( cBuffer, 17, 1 ) ) * 256 + Asc( SubStr( cBuffer, 18, 1 ) )

   nAt := At( Chr( 255 ) + Chr( 192 ), cBuffer ) + 5

   nHeight := Asc( SubStr( cBuffer, nAt,     1 ) ) * 256 + Asc( SubStr( cBuffer, nAt + 1, 1 ) )
   nWidth  := Asc( SubStr( cBuffer, nAt + 2, 1 ) ) * 256 + Asc( SubStr( cBuffer, nAt + 3, 1 ) )

   AAdd( aTemp, nWidth )
   AAdd( aTemp, nHeight )
   AAdd( aTemp, xRes )
   AAdd( aTemp, yRes )
   AAdd( aTemp, nBits )
   AAdd( aTemp, nFrom )
   AAdd( aTemp, nLength )
   AAdd( aTemp, 0 )
   AAdd( aTemp, NIL )

   RETURN aTemp

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BMPInfo( cFile ) CLASS TPDF

   LOCAL cBuffer := Space( 56 ), nHandle
   LOCAL nWidth, nHeight, nBits, nFrom
   LOCAL nLength, xRes, yRes, aTemp := {}

   nHandle := FOpen( cFile )
   FRead( nHandle, @cBuffer, 56 )
   FClose( nHandle )

   nBits := Asc( SubStr( cBuffer, 29, 1 ) )
   nFrom := ( Asc( SubStr( cBuffer, 13, 1 ) ) * 65536 ) + ( Asc( SubStr( cBuffer, 12, 1 ) ) * 256 ) + Asc( SubStr( cBuffer, 11, 1 ) )

   xRes := ( Asc( SubStr( cBuffer, 41, 1 ) ) * 65536 ) + ( Asc( SubStr( cBuffer, 40, 1 ) ) * 256 ) + Asc( SubStr( cBuffer, 39, 1 ) )
   yRes := ( Asc( SubStr( cBuffer, 45, 1 ) ) * 65536 ) + ( Asc( SubStr( cBuffer, 44, 1 ) ) * 256 ) + Asc( SubStr( cBuffer, 43, 1 ) )
   IF xRes == 0
      xRes := 96
   ENDIF
   IF yRes == 0
      yRes := 96
   ENDIF

   nHeight := ( Asc( SubStr( cBuffer, 25, 1 ) ) * 65536 ) + ( Asc( SubStr( cBuffer, 24, 1 ) ) * 256 ) + Asc( SubStr( cBuffer, 23, 1 ) )
   nWidth  := ( Asc( SubStr( cBuffer, 21, 1 ) ) * 65536 ) + ( Asc( SubStr( cBuffer, 20, 1 ) ) * 256 ) + Asc( SubStr( cBuffer, 19, 1 ) )

   nLength := Int( ( ( nWidth * iif( nBits == 24, 32, nBits ) ) + 7 ) / 8 ) * nHeight

   AAdd( aTemp, nWidth )
   AAdd( aTemp, nHeight )
   AAdd( aTemp, xRes )
   AAdd( aTemp, yRes )
   AAdd( aTemp, nBits )
   AAdd( aTemp, nFrom )
   AAdd( aTemp, nLength )
   AAdd( aTemp, 2 )
   IF nBits == 1 .OR. nBits == 24
      AAdd( aTemp, NIL )
   ELSE
      AAdd( aTemp, 54 )
   ENDIF

   RETURN aTemp

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD WriteToFile( cBuffer ) CLASS TPDF

   LOCAL nCount

   nCount := Len( cBuffer )
   FWrite( ::nHandle, cBuffer )
   ::nDocLen += nCount

   RETURN nCount

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookCount( nRecno, nCurLevel ) CLASS TPDF

   LOCAL nTempLevel, nCount := 0, nLen := Len( ::aBookMarks )

   ++ nRecno
   DO WHILE nRecno <= nLen
      nTempLevel := ::aBookMarks[ nRecno, BOOKLEVEL ]
      IF nTempLevel <= nCurLevel
         EXIT
      ELSE
         IF nCurLevel + 1 == nTempLevel
            ++ nCount
         ENDIF
      ENDIF
      ++ nRecno
   ENDDO

   RETURN -1 * nCount

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookFirst( nRecno, nCurLevel, nObj ) CLASS TPDF

   LOCAL nFirst := 0, nLen := Len( ::aBookMarks )

   ++ nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aBookMarks[ nRecno, BOOKLEVEL ]
         nFirst := nRecno
      ENDIF
   ENDIF

   RETURN iif( nFirst == 0, nFirst, nObj + nFirst )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookLast( nRecno, nCurLevel, nObj ) CLASS TPDF

   LOCAL nLast := 0, nLen := Len( ::aBookMarks )

   ++ nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aBookMarks[ nRecno, BOOKLEVEL ]
         DO WHILE nRecno <= nLen .AND. nCurLevel + 1 <= ::aBookMarks[ nRecno, BOOKLEVEL ]
            IF nCurLevel + 1 == ::aBookMarks[ nRecno, BOOKLEVEL ]
               nLast := nRecno
            ENDIF
            ++ nRecno
         ENDDO
      ENDIF
   ENDIF

   RETURN iif( nLast == 0, nLast, nObj + nLast )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookNext( nRecno, nCurLevel, nObj ) CLASS TPDF

   LOCAL nTempLevel, nNext := 0, nLen := Len( ::aBookMarks )

   ++ nRecno
   DO WHILE nRecno <= nLen
      nTempLevel := ::aBookMarks[ nRecno, BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         EXIT
      ELSEIF nCurLevel == nTempLevel
         nNext := nRecno
         EXIT
      ENDIF
      ++ nRecno
   ENDDO

   RETURN iif( nNext == 0, nNext, nObj + nNext )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookParent( nRecno, nCurLevel, nObj ) CLASS TPDF

   LOCAL nTempLevel
   LOCAL nParent := 0

   -- nRecno
   DO WHILE nRecno > 0
      nTempLevel := ::aBookMarks[ nRecno, BOOKLEVEL ]
      IF nTempLevel < nCurLevel
         nParent := nRecno
         EXIT
      ENDIF
      -- nRecno
   ENDDO

   RETURN iif( nParent == 0, nObj - 1, nObj + nParent )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BookPrev( nRecno, nCurLevel, nObj ) CLASS TPDF

   LOCAL nTempLevel
   LOCAL nPrev := 0

   -- nRecno
   DO WHILE nRecno > 0
      nTempLevel := ::aBookMarks[ nRecno, BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         EXIT
      ELSEIF nCurLevel == nTempLevel
         nPrev := nRecno
         EXIT
      ENDIF
      -- nRecno
   ENDDO

   RETURN iif( nPrev == 0, nPrev, nObj + nPrev )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CheckLine( nRow ) CLASS TPDF

   IF nRow + ::nPdfTop > ::nPdfBottom
      ::NewPage()
      nRow := ::aReport[ REPORTLINE ]
   ENDIF
   ::aReport[ REPORTLINE ] := nRow

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetFontInfo( cParam ) CLASS TPDF

   LOCAL cRet

   IF cParam == "NAME"
      IF Left( ::aReport[ TYPE1, ::nFontName ], 5 ) == "Times"
         cRet := "Times"
      ELSEIF Left( ::aReport[ TYPE1, ::nFontName ], 9 ) == "Helvetica"
         cRet := "Helvetica"
      ELSE
         cRet := "Courier"
      ENDIF
   ELSE   // SIZE
      cRet := Int( ( ::nFontName - 1 ) % 4 )
   ENDIF

   RETURN cRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD M2R( m ) CLASS TPDF                       // MM to Row

   RETURN Int( ::aReport[ LPI ] * m / 25.4 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD R2M( r ) CLASS TPDF                       // Row to MM

   RETURN 25.4 * r / ::aReport[ LPI ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD M2X( m ) CLASS TPDF                       // MM to X dots

   RETURN m * 72 / 25.4

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD X2M( x ) CLASS TPDF                       // X dots to MM

   RETURN x * 25.4 / 72

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD M2Y( m ) CLASS TPDF                       // MM to Y dots, Y = 0 it's at the bottom of the page

   RETURN ::aReport[ PAGEY ] - m * 72 / 25.4

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Y2M( y ) CLASS TPDF                       // Y dots to MM

   RETURN ( ::aReport[ PAGEY ] - y ) / 72 * 25.4

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD R2D( r ) CLASS TPDF                       // Row to Y dots, ( 72 / ::aReport[ LPI ] ) is the height of a line

   RETURN ::aReport[ PAGEY ] - r * 72 / ::aReport[ LPI ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint ) CLASS TPDF
/*
 * cString must contain printable chars only, thus Chr(255), Chr(254) and Chr(253)+Color are printed.
 * the only exception is when cString contains only one token.
 */

   LOCAL nFinish, nL, nB, nJ, cToken, nRow

   nFinish := nI

   nL := nLeft
   IF lParagraph
      IF nJustify # 2
         nL += nSpace * nNew
      ENDIF
   ENDIF

   IF nJustify == 3   // right
      nL += nLength - nLineLen
   ELSEIF nJustify == 2   // center
      nL += ( nLength - nLineLen ) / 2
   ENDIF

   ++ nLines
   IF lPrint
      nRow := ::NewLine( 1 )
   ENDIF
   nB := nSpace
   IF nJustify == 4
      nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - nStart )
   ENDIF
   FOR nJ := nStart TO nFinish
      cToken := TPDF_Token( cString, cDelim, nJ )
      IF lPrint
         ::AtSay( cColor + cToken, ::R2M( nRow + ::nPdfTop ), nL, "M" )   
      ENDIF
      nL += ::Length( cToken ) + nB
   NEXT

   nStart := nFinish + 1

   lParagraph := .F.

   nLineLen := 0.00
   nLineLen += nSpace * nNew

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TextNextPara( cString, cDelim, nI ) CLASS TPDF

   LOCAL nAt, cAt, nCRLF, nNew, nRat, nRet := 0

   // check if next spaces paragraph(s)
   nAt   := TPDF_AtToken( cString, cDelim, nI ) + Len( TPDF_Token( cString, cDelim, nI ) )
   cAt   := SubStr( cString, nAt, TPDF_AtToken( cString, cDelim, nI + 1 ) - nAt )
   nCRLF := TPDF_NumAt( CRLF, cAt )
   nRat  := RAt( CRLF, cAt )
   nNew  := Len( cAt ) - nRat - iif( nRat > 0, 1, 0 )
   IF nCRLF > 1 .OR. ( nCRLF == 1 .AND. nNew > 0 )
      nRet := nCRLF
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <windows.h>
#include "hbapi.h"

#pragma ENDDUMP

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ClosePage() CLASS TPDF

   LOCAL cTemp, cBuffer, nBuffer, nRead, nI, k, nImage, nFont, nImageHandle, aImageInfo

   AAdd( ::aPages, ::aReport[ REPORTOBJ ] + 1 )

   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ++ ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Type /Page /Parent 1 0 R" + CRLF + ;
            "/Resources " + LTrim( Str( ++ ::aReport[ REPORTOBJ ] ) ) + " 0 R" + CRLF + ;
            "/MediaBox [ 0 0 " + LTrim( Transform( ::aReport[ PAGEX ], "9999.99" ) ) + " " + ;
            LTrim( Transform( ::aReport[ PAGEY ], "9999.99" ) ) + " ]" + CRLF + ;
            "/Contents " + LTrim( Str( ++ ::aReport[ REPORTOBJ ] ) ) + " 0 R" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   ::WriteToFile( cTemp )

   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] - 1 ) ) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/ColorSpace << /DeviceRGB /DeviceGray >>" + CRLF + ;
            "/ProcSet [ /PDF /Text /ImageB /ImageC ]"
   IF Len( ::aPageFonts ) > 0
      cTemp += CRLF + ;
               "/Font" + CRLF + ;
               "<<"
      FOR nI := 1 TO Len( ::aPageFonts )
         nFont := AScan( ::aFonts, { |arr| arr[ 1 ] == ::aPageFonts[ nI ] } )
         cTemp += CRLF + "/Fo" + LTrim( Str( nFont ) ) + " " + LTrim( Str( ::aFonts[ nFont, 2 ] ) ) + " 0 R"
      NEXT
      cTemp += CRLF + ">>"
   ENDIF
   IF Len( ::aPageImages ) > 0
      cTemp += CRLF + "/XObject" + CRLF + "<<"
      FOR nI := 1 TO Len( ::aPageImages )
         nImage := AScan( ::aImages, { |arr| arr[ 1 ] == ::aPageImages[ nI, 1 ] } )
         IF nImage == 0
            aImageInfo := ::ImageInfo( ::aPageImages[ nI, 1 ] )
            IF Len( aImageInfo ) > 0
               AAdd( ::aImages, { ::aPageImages[ nI, 1 ], ++ ::nNextObj, aImageInfo } )
               nImage := Len( ::aImages )
            ENDIF
         ENDIF
         IF nImage != 0
            cTemp += CRLF + "/Image" + LTrim( Str( nImage ) ) + " " + LTrim( Str( ::aImages[ nImage, 2 ] ) ) + " 0 R"
         ENDIF
      NEXT
      cTemp += CRLF + ">>"
   ENDIF
   cTemp += CRLF + ">>" + CRLF + "endobj" + CRLF
   ::WriteToFile( cTemp )

   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ::aReport[ REPORTOBJ ] ) ) + " 0 obj << /Length " + ;
            LTrim( Str( ::aReport[ REPORTOBJ ] + 1 ) ) + " 0 R >>" + CRLF + ;
            "stream"
   ::WriteToFile( cTemp )

   IF Len( ::aPageImages ) > 0
      cTemp := ""
      FOR nI := 1 TO Len( ::aPageImages )
         nImage := AScan( ::aImages, { |arr| arr[ 1 ] == ::aPageImages[ nI, 1 ] } )
         IF nImage # 0
            cTemp += CRLF + "q"
            cTemp += CRLF + LTrim( Str( iif( ::aPageImages[ nI, 5 ] == 0, ::M2X( ::aImages[ nImage, 3, IMAGE_WIDTH ] / ::aImages[ nImage, 3, IMAGE_XRES ] * 25.4 ), ::aPageImages[ nI, 5 ] ) ) ) + ;
                     " 0 0 " + ;
                     LTrim( Str( iif( ::aPageImages[ nI, 4 ] == 0, ::M2X( ::aImages[ nImage, 3, IMAGE_HEIGHT ] / ::aImages[ nImage, 3, IMAGE_YRES ] * 25.4 ), ::aPageImages[ nI, 4 ] ) ) ) + ;
                     " " + LTrim( Str( ::aPageImages[ nI, 3 ] ) ) + ;
                     " " + LTrim( Str( ::aReport[ PAGEY ] - ::aPageImages[ nI, 2 ] - ;
                                  iif( ::aPageImages[ nI, 4 ] == 0, ::M2X( ::aImages[ nImage, 3, IMAGE_HEIGHT ] / ::aImages[ nImage, 3, IMAGE_YRES ] * 25.4 ), ::aPageImages[ nI, 4 ] ) ) ) + " cm"
            cTemp += CRLF + "/Image" + LTrim( Str( nImage ) ) + " Do"
            cTemp += CRLF + "Q"
         ENDIF
      NEXT
      ::aReport[ PAGEBUFFER ] := cTemp + ::aReport[ PAGEBUFFER ]
   ENDIF

   cTemp := ::aReport[ PAGEBUFFER ] + ;
            CRLF + "endstream" + CRLF + ;
            "endobj" + CRLF
   ::WriteToFile( cTemp )

   AAdd( ::aRefs, ::nDocLen )
   cTemp := LTrim( Str( ++ ::aReport[ REPORTOBJ ] ) ) + " 0 obj" + CRLF + ;
            LTrim( Str( Len( ::aReport[ PAGEBUFFER ] ) ) ) + CRLF + ;
            "endobj" + CRLF
   ::WriteToFile( cTemp )

   FOR nI := 1 TO Len( ::aFonts )
      IF ::aFonts[ nI, 2 ] > ::aReport[ REPORTOBJ ]
         AAdd( ::aRefs, ::nDocLen )
         cTemp := LTrim( Str( ::aFonts[ nI, 2 ] ) ) + " 0 obj" + CRLF + ;
                  "<<" + CRLF + ;
                  "/Type /Font" + CRLF + ;
                  "/Subtype /Type1" + CRLF + ;
                  "/Name /Fo" + LTrim( Str( nI ) ) + CRLF + ;
                  "/BaseFont /" + ::aReport[ TYPE1, ::aFonts[ nI, 1 ] ] + CRLF + ;
                  "/Encoding /WinAnsiEncoding" + CRLF + ;
                  ">>" + CRLF + ;
                  "endobj" + CRLF
         ::WriteToFile( cTemp )
      ENDIF
   NEXT

   FOR nI := 1 TO Len( ::aImages )
      IF ::aImages[ nI, 2 ] > ::aReport[ REPORTOBJ ]
         nImageHandle := FOpen( ::aImages[ nI, 1 ] )

         AAdd( ::aRefs, ::nDocLen )
         cTemp := LTrim( Str( ::aImages[ nI, 2 ] ) ) + " 0 obj" + CRLF + ;
                  "<<" + CRLF + ;
                  "/Type /XObject" + CRLF + ;
                  "/Subtype /Image" + CRLF + ;
                  "/Name /Image" + LTrim( Str( nI ) ) + CRLF + ;
                  "/Filter [" + iif( ::aImages[ nI, 3, IMAGE_TYPE ] == 0, " /DCTDecode", "" ) + " ]" + CRLF + ;     // 0.JPG
                  "/Width " + LTrim( Str( ::aImages[ nI, 3, IMAGE_WIDTH ] ) ) + CRLF + ;
                  "/Height " + LTrim( Str( ::aImages[ nI, 3, IMAGE_HEIGHT ] ) ) + CRLF + ;
                  "/BitsPerComponent " + LTrim( Str( Min( ::aImages[ nI, 3, IMAGE_BITS ], 8 ) ) ) + CRLF
         IF ::aImages[ nI, 3, IMAGE_PALETTE ] == NIL
            cTemp += "/ColorSpace /" + ;
                     iif( ::aImages[ nI, 3, IMAGE_BITS ] == 1, "DeviceGray", ;
                     iif( ::aImages[ nI, 3, IMAGE_BITS ] >= 24, "DeviceCMYK", "DeviceRGB" ) ) + CRLF
         ELSE
             nBuffer := 2 ^ ::aImages[ nI, 3, IMAGE_BITS ]
             cTemp += "/ColorSpace [ /Indexed /DeviceRGB " + LTrim( Str( nBuffer - 1, 3, 0 ) ) + " <"
             cBuffer := Space( nBuffer * 4 )
             FSeek( nImageHandle, ::aImages[ nI, 3, IMAGE_PALETTE ] )
             FRead( nImageHandle, @cBuffer, nBuffer * 4 )
             FOR k := 1 TO nBuffer
                 cTemp += iif( k == 1, "", " " ) + ;
                          TPDF_Hex( Asc( SubStr( cBuffer, ( k * 4 ) - 1, 1 ) ), 2 ) + ;
                          TPDF_Hex( Asc( SubStr( cBuffer, ( k * 4 ) - 2, 1 ) ), 2 ) + ;
                          TPDF_Hex( Asc( SubStr( cBuffer, ( k * 4 ) - 3, 1 ) ), 2 )
             NEXT
             cTemp += "> ]" + CRLF
         ENDIF
         cTemp += "/Length " + LTrim( Str( ::aImages[ nI, 3, IMAGE_LENGTH ] ) ) + CRLF + ;
                  ">>" + CRLF + ;
                  "stream" + CRLF
         ::WriteToFile( cTemp )

         FSeek( nImageHandle, ::aImages[ nI, 3, IMAGE_FROM ] )

         IF ::aImages[ nI, 3, IMAGE_TYPE ] == 2     // 2.BMP
            nBuffer := Int( ( ( ::aImages[ nI, 3, IMAGE_WIDTH ] * ::aImages[ nI, 3, IMAGE_BITS ] ) + 31 ) / 32 ) * 4 * ::aImages[ nI, 3, IMAGE_HEIGHT ]
            cBuffer := Space( nBuffer )
            FRead( nImageHandle, @cBuffer, nBuffer )

            cBuffer := HB_INLINE( cBuffer, ::aImages[ nI, 3, IMAGE_WIDTH ], ::aImages[ nI, 3, IMAGE_HEIGHT ], ::aImages[ nI, 3, IMAGE_BITS ] ) {
               LONG lWidth, lHeight, lLenFrom, lLenTo, lBits, lSize;
               CHAR * cFrom, * cTo, * cBuffer;

               lWidth   = hb_parnl( 2 );
               lHeight  = hb_parnl( 3 );
               lBits    = hb_parnl( 4 );
               lLenFrom = ( ( ( lWidth * lBits ) + 31 ) / 32 ) * 4;
               cFrom    = ( CHAR * ) hb_parc( 1 ) + ( lLenFrom * ( lHeight - 1 ) );

               if( lBits == 24 )
               {
                  lLenTo = ( ( lWidth * 32 ) + 7 ) / 8;
                  lSize = lLenTo * lHeight;
                  cBuffer = ( CHAR * ) hb_xgrab( lSize + 1 );
                  cTo = cBuffer;

                  while( lHeight )
                  {
                     CHAR * cFromCopy, * cToCopy;
                     LONG lCopyPixels;
                     FLOAT fR, fG, fB, fK;

                     cFromCopy   = cFrom;
                     cToCopy     = cTo;
                     lCopyPixels = lWidth;

                     while( lCopyPixels )
                     {
                        fR = ( ( FLOAT ) ( UCHAR ) cFromCopy[ 2 ] ) / 255;
                        fG = ( ( FLOAT ) ( UCHAR ) cFromCopy[ 1 ] ) / 255;
                        fB = ( ( FLOAT ) ( UCHAR ) cFromCopy[ 0 ] ) / 255;
                        fK = ( fR > fG ) ? fR : fG;
                        fK = ( fK > fB ) ? fK : fB;
                        fK = 1 - fK;

                        *cToCopy ++ = ( CHAR ) ( UCHAR ) ( ( ( 1 - fR - fK ) / ( 1 - fK ) ) * 255 );
                        *cToCopy ++ = ( CHAR ) ( UCHAR ) ( ( ( 1 - fG - fK ) / ( 1 - fK ) ) * 255 );
                        *cToCopy ++ = ( CHAR ) ( UCHAR ) ( ( ( 1 - fB - fK ) / ( 1 - fK ) ) * 255 );
                        *cToCopy ++ = ( CHAR ) ( UCHAR ) (                           fK     * 255 );

                        cFromCopy = cFromCopy + 3;
                        lCopyPixels --;
                     }

                     cTo = cTo + lLenTo;
                     cFrom = cFrom - lLenFrom;
                     lHeight --;
                  }
               }
               else
               {
                  lLenTo  = ( ( lWidth * lBits ) + 7 ) / 8;
                  lSize   = lLenTo * lHeight;
                  cBuffer = ( CHAR * ) hb_xgrab( lSize + 1 );
                  cTo     = cBuffer;

                  while( lHeight )
                  {
                     memcpy( cTo, cFrom, lLenTo );
                     cTo = cTo + lLenTo;
                     cFrom = cFrom - lLenFrom;
                     lHeight --;
                  }
               }

               hb_retclen( cBuffer, lSize );
               hb_xfree( cBuffer );
            }

            ::WriteToFile( cBuffer )
         ELSE // IF ::aImages[ nI, 3, IMAGE_TYPE ] == 0 .OR. ::aImages[ nI, 3, IMAGE_TYPE ] == 1     // 0.JPG, 1.TIFF
            nBuffer := 51200
            cBuffer := Space( nBuffer )
            k := 0

            DO WHILE k < ::aImages[ nI, 3, IMAGE_LENGTH ]
               IF k + nBuffer <= ::aImages[ nI, 3, IMAGE_LENGTH ]
                  nRead := nBuffer
               ELSE
                  nRead := ::aImages[ nI, 3, IMAGE_LENGTH ] - k
               ENDIF
               FRead( nImageHandle, @cBuffer, nRead )

               ::WriteToFile( Left( cBuffer, nRead ) )
               k += nRead
            ENDDO
         ENDIF

         cTemp := CRLF + "endstream" + CRLF + "endobj" + CRLF
         ::WriteToFile( cTemp )

         FClose( nImageHandle )
      ENDIF
   NEXT

   ::aReport[ REPORTOBJ ] := ::nNextObj

   ::nNextObj := ::aReport[ REPORTOBJ ] + 4

   ::aReport[ PAGEBUFFER ] := ""

   ::lIsPageActive := .F.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD FilePrint( cFile ) CLASS TPDF

   DEFAULT cFile TO ::cFileName

   RETURN TPDF_RunExternal( ::cPrintApp + " " + cFile + " " + ::cPrintParams )

// See http://www.columbia.edu/~em36/pdftoprinter.html
// PdfToPrinter.exe file.pdf "\\printserver\printername"
// PdfToPrinterSelect.exe file.pdf (to enable printer selection dialog)
// You can use any program that can be started from the command line.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Execute( cFile ) CLASS TPDF

   DEFAULT cFile TO ::cFileName

   RETURN TPDF_RunExternal( ::cExecuteApp + " " + cFile + " " + ::cExecuteParams )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_TimeAsAMPM( cTime )

   IF Val( cTime ) < 12
      cTime += " am"
   ELSEIF Val( cTime ) = 12
      cTime += " pm"
   ELSE
      cTime := Str( Val( cTime ) - 12, 2 ) + SubStr( cTime, 3 ) + " pm"
   ENDIF
   cTime := Left( cTime, 5 ) + SubStr( cTime, 10 )

   RETURN cTime

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_AllToken( cString, cDelimiter, nPointer, nAction )

   LOCAL nTokens := 0, nPos := 1, nLen := Len( cString ), nStart, cRet := 0

   DEFAULT cDelimiter TO Chr( 0 ) + Chr( 9 ) + Chr( 10 ) + Chr( 13 ) + Chr( 26 ) + Chr( 32 ) + Chr( 138 ) + Chr( 141 )

   DEFAULT nAction TO 0
   // nAction == 0 - TPDF_NumToken
   // nAction == 1 - TPDF_Token
   // nAction == 2 - TPDF_AtToken

   DO WHILE nPos <= nLen
      IF ! SubStr( cString, nPos, 1 ) $ cDelimiter
         nStart := nPos
         WHILE nPos <= nLen .AND. ! SubStr( cString, nPos, 1 ) $ cDelimiter
            ++ nPos
         ENDDO
         ++ nTokens
         IF nAction > 0
            IF nPointer == nTokens
               IF nAction == 1
                  cRet := SubStr( cString, nStart, nPos - nStart )
               ELSE
                  cRet := nStart
               ENDIF
               EXIT
            ENDIF
         ENDIF
      ENDIF
      IF SubStr( cString, nPos, 1 ) $ cDelimiter
         DO WHILE nPos <= nLen .AND. SubStr( cString, nPos, 1 ) $ cDelimiter
            ++ nPos
         ENDDO
      ENDIF
      cRet := nTokens
   ENDDO

   RETURN cRet

/*
 * Next 3 function adapted from originals written
 * by Peter Kulek and modified by V.K.
 * See harbour/extras/hbvpdf/core.prg
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_Array2File( cFile, aRay, hFile )

   LOCAL nBytes := 0, i, lOpen := ( hFile # NIL )

   IF ! lOpen
      IF ( hFile := FCreate( cFile, FC_NORMAL ) ) == F_ERROR
         RETURN nBytes
      ENDIF
   ENDIF

   nBytes += TPDF_WriteData( hFile, aRay )
   IF HB_ISARRAY( aRay )
      FOR i := 1 TO Len( aRay )
         nBytes += TPDF_Array2File( cFile, aRay[ i ], hFile )
      NEXT
   ENDIF

   IF ! lOpen
      FClose( hFile )
   ENDIF

   RETURN nBytes

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_WriteData( hFile, xData )

   LOCAL cData := ValType( xData )

   IF HB_ISSTRING( xData )
      cData += I2Bin( Len( xData ) ) + xData
   ELSEIF HB_ISNUMERIC( xData )
      cData += I2Bin( Len( AllTrim( Str( xData ) ) ) ) + AllTrim( Str( xData ) )
   ELSEIF HB_ISDATE( xData )
      cData += I2Bin( 8 ) + DToS( xData )
   ELSEIF HB_ISLOGICAL( xData )
      cData += I2Bin( 1 ) + iif( xData, "T", "F" )
   ELSEIF HB_ISARRAY( xData )
      cData += I2Bin( Len( xData ) )
   ELSE
      cData += I2Bin( 0 )   // NIL
   ENDIF

   RETURN FWrite( hFile, cData, Len( cData ) )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_File2Array( cFile, nLen, hFile )

   LOCAL cData, cType, nDataLen, nBytes
   LOCAL nDepth := 0
   LOCAL aRay   := {}

   IF hFile == NIL
      IF ( hFile := FOpen( cFile, FO_READ ) ) == F_ERROR
         RETURN aRay
      ENDIF
      cData := Space( 3 )
      FRead( hFile, @cData, 3 )
      IF Left( cData, 1 ) != "A"   // if not an array
         FClose( hFile )                                    
         RETURN aRay
      ENDIF
      nLen := Bin2I( Right( cData, 2 ) )
   ENDIF

   DO WHILE nDepth < nLen
      cData  := Space( 3 )
      nBytes := FRead( hFile, @cData, 3 )
      IF nBytes < 3
         EXIT
      ENDIF

      cType := PadL( cData, 1 )
      nDataLen := Bin2I( Right( cData, 2 ) )
      IF cType != "A"
         cData := Space( nDataLen )
         nBytes:= FRead( hFile, @cData, nDataLen )
         IF nBytes < nDataLen
            EXIT
         ENDIF
      ENDIF

      nDepth ++
      AAdd( aRay, NIL )
      IF cType == "C"
         aRay[ nDepth ] := cData
      ELSEIF cType == "N"
         aRay[ nDepth ] := Val( cData )
      ELSEIF cType == "D"
         aRay[ nDepth ] := SToD( cData )
      ELSEIF cType == "L"
         aRay[ nDepth ] := ( cData == "T" )
      ELSEIF cType == "A"
         aRay[ nDepth ] := TPDF_File2Array( NIL, nDataLen, hFile )
      ENDIF
   ENDDO

   IF cFile != NIL
      FClose( hFile )
   ENDIF

   RETURN aRay

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_Hex( nNum, nLen )

   LOCAL cHex, nDigit

   cHex := ""
   DO WHILE nLen > 0
      nDigit := nNum % 16
      nNum := Int( nNum / 16 )
      cHex := iif( nDigit > 9, Chr( nDigit + 55 ), Chr( nDigit + 48 ) ) + cHex
      nLen --
   ENDDO

   RETURN cHex

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_NumAt( cSearch, cString )

   LOCAL n := 0, nAt, nPos := 0

   DO WHILE ( nAt := At( cSearch, SubStr( cString, nPos + 1 ) ) ) > 0
      nPos += nAt
      ++ n
   ENDDO

   RETURN n

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TPDF_RunExternal( cCmd, cVerb, cFile )

   LOCAL lRet := .T.

   IF cVerb # NIL
      ShellExecute( NIL, cVerb, cFile, NIL, NIL, 1 )
   ELSE
      __Run( cCmd )
   ENDIF

   RETURN lRet
