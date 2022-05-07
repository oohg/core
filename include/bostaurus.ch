/*
 * $Id: bostaurus.ch $
 */
/*
 * OOHG source code:
 * Bos Taurus library definitions
 *
 * Copyright 2015-2022 Fernando Yurisich <fyurisich@oohg.org> and contributors of
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


#ifndef _BT_INFO_NAME_

// BT_INFONAME()
#define _BT_INFO_NAME_                             "Bos Taurus"


// BT_INFOVERSION()
#define _BT_INFO_MAJOR_VERSION_                    1
#define _BT_INFO_MINOR_VERSION_                    0
#define _BT_INFO_PATCHLEVEL_                       5


// BT_INFOAUTHOR()
#define _BT_INFO_AUTHOR_                           "(c) Dr. Claudio Soto (from Uruguay)"

// BT_DC_CREATE()
// Type
#define BT_HDC_DESKTOP                             1
#define BT_HDC_WINDOW                              2
#define BT_HDC_ALLCLIENTAREA                       3
#define BT_HDC_INVALIDCLIENTAREA                   4
#define BT_HDC_BITMAP                              5

// BT_SCR_GETINFO()
// Mode
#define BT_SCR_DESKTOP                             0
#define BT_SCR_WINDOW                              1
#define BT_SCR_CLIENTAREA                          2

// BT_SCR_GETINFO()
// Info
#define BT_SCR_INFO_WIDTH                          0
#define BT_SCR_INFO_HEIGHT                         1

// BT_DRAWEDGE()
// nEdge
#define BDR_RAISEDOUTER                            0x0001
#define BDR_SUNKENOUTER                            0x0002
#define BDR_RAISEDINNER                            0x0004
#define BDR_SUNKENINNER                            0x0008
#define BDR_OUTER                                  (BDR_RAISEDOUTER + BDR_SUNKENOUTER)
#define BDR_INNER                                  (BDR_RAISEDINNER + BDR_SUNKENINNER)
#define BDR_RAISED                                 (BDR_RAISEDOUTER + BDR_RAISEDINNER)
#define BDR_SUNKEN                                 (BDR_SUNKENOUTER + BDR_SUNKENINNER)
#define EDGE_RAISED                                (BDR_RAISEDOUTER + BDR_RAISEDINNER)
#define EDGE_SUNKEN                                (BDR_SUNKENOUTER + BDR_SUNKENINNER)
#define EDGE_ETCHED                                (BDR_SUNKENOUTER + BDR_RAISEDINNER)
#define EDGE_BUMP                                  (BDR_RAISEDOUTER + BDR_SUNKENINNER)

// BT_DRAWEDGE()
// nGrfFlags
#define BF_LEFT                                    0x0001
#define BF_TOP                                     0x0002
#define BF_RIGHT                                   0x0004
#define BF_BOTTOM                                  0x0008
#define BF_TOPLEFT                                 (BF_TOP + BF_LEFT)
#define BF_TOPRIGHT                                (BF_TOP + BF_RIGHT)
#define BF_BOTTOMLEFT                              (BF_BOTTOM + BF_LEFT)
#define BF_BOTTOMRIGHT                             (BF_BOTTOM + BF_RIGHT)
#define BF_RECT                                    (BF_LEFT + BF_TOP + BF_RIGHT + BF_BOTTOM)
#define BF_DIAGONAL                                0x0010
#define BF_DIAGONAL_ENDTOPRIGHT                    (BF_DIAGONAL + BF_TOP + BF_RIGHT)
#define BF_DIAGONAL_ENDTOPLEFT                     (BF_DIAGONAL + BF_TOP + BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMLEFT                  (BF_DIAGONAL + BF_BOTTOM + BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMRIGHT                 (BF_DIAGONAL + BF_BOTTOM + BF_RIGHT)
#define BF_MIDDLE                                  0x0800
#define BF_SOFT                                    0x1000
#define BF_ADJUST                                  0x2000
#define BF_FLAT                                    0x4000
#define BF_MONO                                    0x8000

// BT_DRAW_HDC_FILLEDOBJECT()
// Type
#define BT_FILLRECTANGLE                           1
#define BT_FILLELLIPSE                             2
#define BT_FILLROUNDRECT                           3  // RoundWidth , RoundHeight
#define BT_FILLFLOOD                               4

// BT_DRAW_HDC_BITMAP(), BT_BMP_PASTE()
// Action
#define BT_BITMAP_OPAQUE                           0
#define BT_BITMAP_TRANSPARENT                      1

// BT_DRAW_HDC_BITMAP(), BT_DRAW_HDC_BITMAPALPHABLEND()
// Mode_Stretch
#define BT_SCALE                                   0
#define BT_STRETCH                                 1
#define BT_COPY                                    3

// BT_DRAW_HDC_BITMAPALPHABLEND()
// Alpha (0 to 255)
#define BT_ALPHABLEND_TRANSPARENT                  0
#define BT_ALPHABLEND_OPAQUE                       255

// BT_DRAW_HDC_GRADIENTFILL()
// Mode
#define BT_GRADIENTFILL_HORIZONTAL                 0
#define BT_GRADIENTFILL_VERTICAL                   1

// BT_DRAW_HDC_TEXTOUT(), BT_DRAW_HDC_DRAWTEXT()
// Type
#define BT_TEXT_OPAQUE                             0
#define BT_TEXT_TRANSPARENT                        1
#define BT_TEXT_BOLD                               2
#define BT_TEXT_ITALIC                             4
#define BT_TEXT_UNDERLINE                          8
#define BT_TEXT_STRIKEOUT                          16

// BT_DRAW_HDC_TEXTOUT()
// Align
#define BT_TEXT_LEFT                               0
#define BT_TEXT_CENTER                             6
#define BT_TEXT_RIGHT                              2
#define BT_TEXT_TOP                                0
#define BT_TEXT_BASELINE                           24
#define BT_TEXT_BOTTOM                             8

// BT_DRAW_HDC_TEXTOUT()
// Orientation
#define BT_TEXT_NORMAL_ORIENTATION                 0
#define BT_TEXT_VERTICAL_ASCENDANT                 90
#define BT_TEXT_VERTICAL_DESCENDANT                -90
#define BT_TEXT_DIAGONAL_ASCENDANT                 45
#define BT_TEXT_DIAGONAL_DESCENDANT                -45

// BT_DRAW_HDC_TO_HDC()
// Action
#define BT_HDC_OPAQUE                              0
#define BT_HDC_TRANSPARENT                         1

// BT_BMP_SAVEFILE()
// nTypePicture
#define BT_FILEFORMAT_BMP                          0
#define BT_FILEFORMAT_JPG                          1
#define BT_FILEFORMAT_GIF                          2
#define BT_FILEFORMAT_TIF                          3
#define BT_FILEFORMAT_PNG                          4

// BT_BMP_CAPTURESCR()
// Mode
#define BT_BITMAP_CAPTURE_DESKTOP                  0
#define BT_BITMAP_CAPTURE_WINDOW                   1
#define BT_BITMAP_CAPTURE_CLIENTAREA               2

// BT_BMP_GETINFO()
// Info
#define BT_BITMAP_INFO_WIDTH                       0
#define BT_BITMAP_INFO_HEIGHT                      1
#define BT_BITMAP_INFO_BITSPIXEL                   2
#define BT_BITMAP_INFO_GETCOLORPIXEL               3

// BT_BMP_PROCESS()
// Action                                                     Value
#define BT_BMP_PROCESS_INVERT                      0          // NIL
#define BT_BMP_PROCESS_GRAYNESS                    1          // Gray_Level     = 0 to 100%
#define BT_BMP_PROCESS_BRIGHTNESS                  2          // Light_Level    = -255 To +255
#define BT_BMP_PROCESS_CONTRAST                    3          // Contrast_Angle = angle in radians
#define BT_BMP_PROCESS_MODIFYCOLOR                 4          // { R = -255 To +255, G = -255 To +255, B = -255 To +255 }
#define BT_BMP_PROCESS_GAMMACORRECT                5          // {RedGamma = 0.2 To 5.0, GreenGamma = 0.2 To 5.0, BlueGamma = 0.2 To 5.0}

// BT_BMP_PROCESS()
// Gray_Level (0 to 100%)
#define BT_BITMAP_GRAY_NONE                        0
#define BT_BITMAP_GRAY_FULL                        100

// BT_BMP_PROCESS()
// Light_Level (-255 to +255)
#define BT_BITMAP_LIGHT_BLACK                      -255
#define BT_BITMAP_LIGHT_NONE                       0
#define BT_BITMAP_LIGHT_WHITE                      255

// BT_BMP_TRANSFORM()
// Mode
#define BT_BITMAP_REFLECT_HORIZONTAL               1
#define BT_BITMAP_REFLECT_VERTICAL                 2
#define BT_BITMAP_ROTATE                           4   // Angle = 0 To 360º       Color_Fill_Bk = color to fill the empty spaces the background

// BT_DRAW_HDC_PIXEL()
// Action
#define BT_HDC_GETPIXEL                            0
#define BT_HDC_SETPIXEL                            1

// BT_BMP_COPYANDRESIZE()
// nAlgorithm
#define BT_RESIZE_COLORONCOLOR                     0
#define BT_RESIZE_HALFTONE                         1
#define BT_RESIZE_BILINEAR                         2

// BT_REGIONCOMBINE()
// nCombineMode
#define BT_REGION_AND                              1
#define BT_REGION_OR                               2
#define BT_REGION_XOR                              3
#define BT_REGION_DIFF                             4
#define BT_REGION_COPY                             5

// BT_REGIONCOMBINE()
// Return value
#define BT_REGION_ERROR                            0
#define BT_REGION_NULLREGION                       1
#define BT_REGION_SIMPLEREGION                     2
#define BT_REGION_COMPLEXREGION                    3

// BT_DIRECTORYINFO()
// nTypeList
#define BT_DIRECTORYINFO_INFOROOT                  -1
#define BT_DIRECTORYINFO_LISTALL                   0
#define BT_DIRECTORYINFO_LISTFOLDER                1
#define BT_DIRECTORYINFO_LISTNONFOLDER             2
#define BT_DIRECTORYINFO_NAME                      1
#define BT_DIRECTORYINFO_DATE                      2
#define BT_DIRECTORYINFO_TYPE                      3
#define BT_DIRECTORYINFO_SIZE                      4
#define BT_DIRECTORYINFO_FULLNAME                  5
#define BT_DIRECTORYINFO_INTERNALDATA_TYPE         6
#define BT_DIRECTORYINFO_INTERNALDATA_DATE         7
#define BT_DIRECTORYINFO_INTERNALDATA_IMAGEINDEX   8
#define BT_DIRECTORYINFO_INTERNALDATA_FOLDER       "D-"
#define BT_DIRECTORYINFO_INTERNALDATA_HASSUBFOLDER "D+"
#define BT_DIRECTORYINFO_INTERNALDATA_NOFOLDER     "F"

#xtranslate BT_DIRECTORYINFO( [ <param, ...> ] ) ;
   => ;
      DirectoryInfo( <param> )

// BT_DRAW_HDC_POLY()
// nPOLY
#define BT_DRAW_POLYLINE                           0
#define BT_DRAW_POLYGON                            1
#define BT_DRAW_POLYBEZIER                         2

// BT_DRAW_HDC_ARCX()
// nArcType
#define BT_DRAW_ARC                                0
#define BT_DRAW_CHORD                              1
#define BT_DRAW_PIE                                2

// PSEUDO-FUNCTIONS
#ifndef __OOHG__
#ifndef __HBPRN__
#translate RGB( <nRed>, <nGreen>, <nBlue> ) ;
   => ;
      ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )
#define ArrayRGB_TO_COLORREF( aRGB ) RGB( aRGB[1], aRGB[2], aRGB[3] )
#define COLORREF_TO_ArrayRGB( nRGB ) { hb_bitAnd( nRGB, 0xFF ), hb_bitAnd( hb_bitShift( nRGB, -8 ), 0xFF ), hb_bitAnd( hb_bitShift( nRGB, -16 ), 0xFF ) }
#endif
#endif

#endif
