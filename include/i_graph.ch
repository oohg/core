/*
 * $Id: i_graph.ch $
 */
/*
 * ooHG source code:
 * Graphic drawing definitions
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


#xcommand DRAW TEXT IN WINDOW <windowname> ;
      AT <nRow>, <nCol> ;
      VALUE <cString> ;
      [ FONT <cFont> ] ;
      [ SIZE <nSize> ] ;
      [ BACKCOLOR <aBkRGB> ] ;
      [ FONTCOLOR <aRGB> ] ;
      [ <lBold: BOLD> ] ;
      [ <lItalic: ITALIC> ] ;
      [ <lUnderline: UNDERLINE> ] ;
      [ <lStrikeout: STRIKEOUT> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
      DrawTextOut( <(windowname)>, <nRow>, <nCol>, <cString>, <aRGB>, ;
            <aBkRGB>, <cFont>, <nSize>, <.lBold.>, <.lItalic.>, ;
            <.lUnderline.>, <.lStrikeout.>, <.transparent.> )

#xcommand DRAW LINE IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>,<tcol> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <pnwidth> ] ;
   => ;
      DrawLine( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, ;
            [<penrgb>], <pnwidth> )

#xcommand DRAW RECTANGLE IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <pnwidth> ] ;
      [ FILLCOLOR <fillrgb> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
      DrawRect( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, [<penrgb>], ;
            <pnwidth>, [<fillrgb>], [<.transparent.>] )

#xcommand DRAW ROUNDRECTANGLE IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
      ROUNDWIDTH <width> ;
      ROUNDHEIGHT <height>;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <pnwidth> ] ;
      [ FILLCOLOR <fillrgb> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
      DrawRoundRect( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, <width>, ;
            <height>, [<penrgb>], <pnwidth>, [<fillrgb>], [<.transparent.>] )

#xcommand DRAW ELLIPSE IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <pnwidth> ] ;
      [ FILLCOLOR <fillrgb> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
      DrawEllipse( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, [<penrgb>], ;
            <pnwidth>, [<fillrgb>], [<.transparent.>] )

#xcommand DRAW ARC IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
      FROM RADIAL <rrow>, <rcol> ;
      TO RADIAL <rrow1>, <rcol1> ;
      [ PENCOLOR <penrgb>] ;
      [ PENWIDTH <pnwidth>] ;
   => ;
   DrawArc( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, <rrow>, <rcol>, ;
         <rrow1>, <rcol1>, [<penrgb>], <pnwidth> )

#xcommand DRAW PIE IN WINDOW <windowname> AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
      FROM RADIAL <rrow>, <rcol> ;
      TO RADIAL <rrow1>, <rcol1> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <pnwidth> ] ;
      [ FILLCOLOR <fillrgb> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
   DrawPie( <(windowname)>, <frow>, <fcol>, <trow>, <tcol>, <rrow>, <rcol>, ;
         <rrow1>, <rcol1>, [<penrgb>], <pnwidth>, [<fillrgb>], [<.transparent.>] )

/*
 * POINTS must be specified using this syntax:
 *    { {row1, col1}, {row2, col2}, {row3, col3}, ... }
 */
#xcommand DRAW POLYGON IN WINDOW <windowname> ;
      POINTS <pointsarr> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <penwidth> ] ;
      [ FILLCOLOR <fillrgb> ] ;
      [ <transparent: TRANSPARENT> ] ;
   => ;
      DrawPolygon( <(windowname)>, [<pointsarr>], [<penrgb>], ;
            <penwidth>, [<fillrgb>], [<.transparent.>] )

#xcommand DRAW POLYBEZIER IN WINDOW <windowname> ;
      POINTS <pointsarr> ;
      [ PENCOLOR <penrgb> ] ;
      [ PENWIDTH <penwidth> ] ;
   => ;
      DrawPolyBezier( <(windowname)>, [<pointsarr>], [<penrgb>], <penwidth> )

#xcommand ERASE WINDOW <windowname> ;
   => ;
      EraseWindow( <(windowname)> )

#xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
   => ;
      <uVar1> := IIF( <uVar1> == NIL, <uVal1>, <uVar1> ) ;;
      [ <uVarN> := IIF( <uVarN> == NIL, <uValN>, <uVarN> ) ; ]

#ifndef _BT_INFO_NAME_
#ifndef __HBPRN__
#translate RGB( <nRed>, <nGreen>, <nBlue> ) ;
   => ;
      ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )
#define ArrayRGB_TO_COLORREF( aRGB ) RGB( aRGB[1], aRGB[2], aRGB[3] )
#define COLORREF_TO_ArrayRGB( nRGB ) { hb_bitAnd( nRGB, 0xFF ), hb_bitAnd( hb_bitShift( nRGB, -8 ), 0xFF ), hb_bitAnd( hb_bitShift( nRGB, -16 ), 0xFF ) }
#endif
#endif


#xcommand DRAW GRAPH IN WINDOW <windowname> ;
      AT <nT>, <nL> ;
      TO <nB>, <nR> ;
      TITLE <cTitle> ;
      TYPE PIE ;
      SERIES <aSer> ;
      DEPTH <nD> ;
      SERIENAMES <aName> ;
      COLORS <aColor> ;
      [ <l3D: 3DVIEW> ] ;
      [ <lxVal: SHOWXVALUES> ] ;
      [ <lSLeg: SHOWLEGENDS> ] ;
      [ <lNoBorder: NOBORDER> ] ;
   => ;
      DrawPieGraph( <(windowname)>, <nT>, <nL>, <nB>, <nR>, <aSer>, <aName>, ;
            <aColor>, <cTitle>, <nD>, <.l3D.>, <.lxVal.>, <.lSLeg.>, ;
            <.lNoBorder.> )

/*
 * <nType> valid values are:
 *    "BARS" or 1
 *    "LINES" or 2
 *    "POINTS" or 3
 */
#xcommand DRAW GRAPH ;
      IN WINDOW <windowname> ;
      AT <nT>, <nL> ;
      [ TO <nB>, <nR> ] ;
      [ TITLE <cTitle> ] ;
      TYPE <nType> ;
      SERIES <aSer> ;
      YVALUES <aYVal> ;
      DEPTH <nD> ;
      [ BARWIDTH <nW> ] ;
      HVALUES <nRange> ;
      SERIENAMES <aName> ;
      COLORS <aColor> ;
      [ <l3D: 3DVIEW> ] ;
      [ <lGrid: SHOWGRID> ] ;
      [ <lxVal: SHOWXVALUES> ] ;
      [ <lyVal: SHOWYVALUES> ] ;
      [ <lSLeg: SHOWLEGENDS> ] ;
      [ LEGENDSWIDTH <nLegendWindth> ] ;
      [ <lNoborder: NOBORDER> ] ;
   => ;
      GraphShow( <(windowname)>, <nT>, <nL>, <nB>, <nR>, NIL, NIL, <aSer>, ;
            <cTitle>, <aYVal>, <nD>, <nW>, NIL, <nRange>, <.l3D.>, <.lGrid.>, ;
            .F., .F., <.lxVal.>, <.lyVal.>, <.lSLeg.>, <aName>, <aColor>, ;
            <(nType)>, .F., NIL, <nLegendWindth>, <.lNoborder.> )

#xcommand DRAW PANEL IN WINDOW <windowname> ;
      AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
   => ;
      DrawWindowBoxRaised( <(windowname)>, <frow>, <fcol>, <trow>, <tcol> )

#xcommand DRAW BOX IN WINDOW <windowname> ;
      AT <frow>, <fcol> ;
      TO <trow>, <tcol> ;
   => ;
      DrawWindowBoxIn( <(windowname)>, <frow>, <fcol>, <trow>, <tcol> )
