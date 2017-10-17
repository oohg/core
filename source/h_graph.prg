/*
 * $Id: h_graph.prg,v 1.16 2017-08-25 19:42:18 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Graphic functions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
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
 * along with this software; see the file COPYING.  If not, write to
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


Function DrawTextOut( window, row, col, string, fontcolor, backcolor, fontname, fontsize, bold, italic, underline, strikeout, transparent )
Local oWnd, oControl
Local row1, col1

   oControl := TControl()
   oControl:SetForm( , window, FontName, FontSize, FontColor, BackColor )
   oWnd := oControl:Parent

   If oWnd:hWnd > 0
      oControl:SetFont( , , bold, italic, underline, strikeout )
      col1 := col + GetTextWidth( 0, string, oControl:FontHandle )
      row1 := row + GetTextHeight( 0, string, oControl:FontHandle )
      DeleteObject( oControl:FontHandle )

      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand_Text( oWnd:hWnd, 0, row, col, row1, col1, oControl:FontColor, string, oControl:BackColor, transparent, bold, italic, underline, strikeout, oControl:fontname, oControl:fontsize ) )
   EndIf
Return Nil


Function DrawLine( window, row, col, row1, col1, penrgb, penwidth )
Local oWnd := GetFormObject( window )

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
/*
      linedraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth)

      aAdd ( oWnd:GraphTasks, { || linedraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 1, row, col, row1, col1, penrgb, penwidth ) )
   EndIf
Return Nil


Function DrawRect( window, row, col, row1, col1, penrgb, penwidth, fillrgb )
Local oWnd := GetFormObject( window )
Local fill

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      If ValType( fillrgb ) == "U"
         fillrgb := {255, 255, 255}
         fill := .F.
      Else
         fill := .T.
      EndIf
/*
      rectdraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth, fillrgb, fill)

      aAdd ( oWnd:GraphTasks, { || rectdraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth, fillrgb, fill) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 2, row, col, row1, col1, penrgb, penwidth, fillrgb, fill ) )
   EndIf
Return Nil


Function DrawRoundRect( window, row, col, row1, col1, width, height, penrgb, penwidth, fillrgb )
Local oWnd := GetFormObject( window )
Local fill

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      If ValType( fillrgb ) == "U"
         fillrgb := {255, 255, 255}
         fill := .F.
      Else
         fill := .T.
      EndIf
/*
      roundrectdraw( oWnd:hWnd, row, col, row1, col1, width, height, penrgb, penwidth, fillrgb, fill)

      aAdd ( oWnd:GraphTasks, { || roundrectdraw( oWnd:hWnd, row, col, row1, col1, width, height, penrgb, penwidth, fillrgb, fill) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 3, row, col, row1, col1, penrgb, penwidth, fillrgb, fill, , , , , width, height ) )
   EndIf
Return Nil


Function DrawEllipse( window, row, col, row1, col1, penrgb, penwidth, fillrgb )
Local oWnd := GetFormObject( window )
Local fill

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      If ValType( fillrgb ) == "U"
         fillrgb := {255, 255, 255}
         fill := .F.
      Else
         fill := .T.
      EndIf
/*
      ellipsedraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth, fillrgb, fill)

      aAdd ( oWnd:GraphTasks, { || ellipsedraw( oWnd:hWnd, row, col, row1, col1, penrgb, penwidth, fillrgb, fill) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 4, row, col, row1, col1, penrgb, penwidth, fillrgb, fill ) )
   EndIf
Return Nil


Function DrawArc( window, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth )
Local oWnd := GetFormObject( window )

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
/*
      arcdraw( oWnd:hWnd, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth)
      aAdd ( oWnd:GraphTasks, { || arcdraw( oWnd:hWnd, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 5, row, col, row1, col1, penrgb, penwidth, , , rowr, colr, rowr1, colr1 ) )
   EndIf
Return Nil


Function DrawPie( window, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth, fillrgb )
Local oWnd := GetFormObject( window )
Local fill

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      If ValType( fillrgb ) == "U"
         fillrgb := {255, 255, 255}
         fill := .F.
      Else
         fill := .T.
      EndIf
/*
      piedraw( oWnd:hWnd, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth, fillrgb, fill)

      aAdd ( oWnd:GraphTasks, { || piedraw( oWnd:hWnd, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth, fillrgb, fill) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 6, row, col, row1, col1, penrgb, penwidth, fillrgb, fill, rowr, colr, rowr1, colr1 ) )
   EndIf
Return Nil


Function DrawPolygon( window, apoints, penrgb, penwidth, fillrgb )
Local oWnd := GetFormObject( window )
Local fill
Local xarr
Local yarr

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      If ValType( fillrgb ) == "U"
         fillrgb := {255, 255, 255}
         fill := .F.
      Else
         fill := .T.
      EndIf
      xarr := Array( Len( apoints ) )
      yarr := Array( Len( apoints ) )
      aEval( apoints, { |a, i| yarr[ i ] := a[ 1 ], xarr[ i ] := a[ 2 ] } )
/*
      polygondraw(oWnd:hWnd, xarr, yarr, penrgb, penwidth, fillrgb, fill)
      aAdd( oWnd:GraphTasks, {||polygondraw(oWnd:hWnd, xarr, yarr, penrgb, penwidth, fillrgb, fill)})
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 8, yarr, xarr, , , penrgb, penwidth, fillrgb, fill ) )
   EndIf
Return Nil


Function DrawPolybezier( window, apoints, penrgb, penwidth )
Local oWnd := GetFormObject( window )
Local xarr
Local yarr

   If oWnd:hWnd > 0
      If ValType( penrgb ) == "U"
         penrgb := {0, 0, 0}
      EndIf
      If ValType( penwidth ) == "U"
         penwidth := 1
      EndIf
      xarr := Array( Len( apoints ) )
      yarr := Array( Len( apoints ) )
      aEval( apoints, { |a, i| yarr[ i ] := a[ 1 ], xarr[ i ] := a[ 2 ] } )
/*
      polybezierdraw(oWnd:hWnd, xarr, yarr, penrgb, penwidth)
      aAdd( oWnd:GraphTasks, {||polybezierdraw(oWnd:hWnd, xarr, yarr, penrgb, penwidth)})
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 9, yarr, xarr, , , penrgb, penwidth ) )
   EndIf
Return Nil


Function EraseWindow( window )
Local oWnd := GetFormObject( window )

   If oWnd:hWnd > 0
      aEval( oWnd:GraphControls, {|a| DoMethod( window, a, "Release" ) } )
      aSize( oWnd:GraphControls, 0 )
      aSize( oWnd:GraphTasks, 0 )
      aSize( oWnd:GraphData, 0 )
      oWnd:GraphCommand := Nil
      RedrawWindow( oWnd:hWnd )
   EndIf
Return Nil


/* Copyright Alfredo Arteaga 14/10/2001 original idea
 *
 * Grigory Filatov 23/06/2003 translation for MiniGUI
 *
 * Roberto Lopez 23/06/2003 command definition
 *
 * Copyright Alfredo Arteaga TGRAPH 2, 12/03/2002
 *
 * Grigory Filatov 26/02/2004 translation #2 for MiniGUI
 */
Procedure GraphShow( parent, nTop, nLeft, nBottom, nRight, nHeight, nWidth, aData, cTitle, aYVals, nBarD, nWideB, nSep, nXRanges, ;
   l3D, lGrid, lxGrid, lyGrid, lxVal, lyVal, lLegends, aSeries, aColors, uType, lViewVal, cPicture, nLegendWindth, lNoborder )
Local nI, nJ, nPos, nMax, nMin, nMaxBar, nDeep
Local nRange, nResH, nResV,  nWide, aPoint, cName
Local nXMax, nXMin, nHigh, nRel, nZero, nRPos, nRNeg, nType, lError
Local oWnd := GetFormObject( parent )

   DEFAULT cTitle   := ""
   DEFAULT nSep     := 0
   DEFAULT cPicture := "999, 999.99"
   DEFAULT nLegendWindth := 50
   DEFAULT lNoborder := .F.

/*
   #define BARS   1
   #define LINES  2
   #define POINTS 3
 */
   lError := .F.
   If ValType( uType ) == "N"
      If uType == 1 .or. uType == 2 .or. uType == 3
         nType := uType
      Else
         lError := .T.
      EndIf
   ElseIf ValType( uType ) $ "CM"
      uType := Upper( uType )

      If uType == "BARS"
         nType := 1
      ElseIf uType == "LINES"
         nType := 2
      ElseIf uType == "POINTS"
         nType := 3
      Else
         lError := .T.
      EndIf
   Else
      lError := .T.
   EndIf
   If lError
      MsgOOHGError( "DRAW GRAPH: Graph type is not valid. Program terminated." )
   EndIf

   If ! lLegends
      nLegendWindth := 0
   EndIf

   If ( Len( aSeries ) != Len( aData ) ) .or. ;
      ( Len( aSeries ) != Len( aColors ) )
      MsgOOHGError( "DRAW GRAPH: 'Series' / 'SerieNames' / 'Colors' Arrays size mismatch. Program terminated." )
   EndIf

   If _IsControlDefined( 'Graph_Title', parent )
      DoMethod( parent, "Graph_Title", "Release" )
   EndIf
   If ( nPos := aScan( oWnd:GraphControls, "Graph_Title" ) ) > 0
      aDel( oWnd:GraphControls, nPos )
      aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
   EndIf

   For ni := 1 To Len( aSeries )
      cName := "Ser_Name_" + lTrim( Str( ni ) )
      If _IsControlDefined( cName, parent )
         DoMethod( parent, cName, "Release" )
      EndIf
      If ( nPos := aScan( oWnd:GraphControls, cName ) ) > 0
         aDel( oWnd:GraphControls, nPos )
         aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
      EndIf
   Next

   For ni := 0 To nXRanges
      cName := "xPVal_Name_" + lTrim( Str( ni ) )
      If _IsControlDefined( cName, parent )
         DoMethod( parent, cName, "Release" )
      EndIf
      If ( nPos := aScan( oWnd:GraphControls, cName ) ) > 0
         aDel( oWnd:GraphControls, nPos )
         aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
      EndIf
   Next

   For ni := 0 To nXRanges
      cName := "xNVal_Name_" + lTrim( Str( ni ) )
      If _IsControlDefined( cName, parent )
         DoMethod( parent, cName, "Release" )
      EndIf
      If ( nPos := aScan( oWnd:GraphControls, cName ) ) > 0
         aDel( oWnd:GraphControls, nPos )
         aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
      EndIf
   Next

   For ni := 1 To nMax( aData )
      cName := "yVal_Name_" + lTrim( Str( ni ) )
      If _IsControlDefined( cName, parent )
         DoMethod( parent, cName, "Release" )
      EndIf
      If ( nPos := aScan( oWnd:GraphControls, cName ) ) > 0
         aDel( oWnd:GraphControls, nPos )
         aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
      EndIf
   Next

   For nI := 1 To Len( aData[ 1 ] )
      For nJ := 1 To Len( aSeries )
         cName := "Data_Name_" + lTrim( Str( nI ) ) + lTrim( Str( nJ ) )
         If _IsControlDefined( cName, parent )
            DoMethod( parent, cName, "Release" )
         EndIf
         If ( nPos := aScan( oWnd:GraphControls, cName ) ) > 0
            aDel( oWnd:GraphControls, nPos )
            aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
         EndIf
      Next nJ
   Next nI

   If lGrid
      lxGrid := lyGrid := .T.
   EndIf
   If nBottom <> Nil .and. nRight <> Nil
      nHeight := nBottom - nTop / 2
      nWidth  := nRight - nLeft / 2
      nBottom -= If(lyVal, 42, 32)
      nRight  -= 32 + nLegendWindth
   EndIf
   nTop    += 1 + If( Empty( cTitle ), 30, 44 )             // Top gap
   nLeft   += 1 + If( lxVal, 80 + nBarD, 30 + nBarD )       // Left
   DEFAULT nBottom := nHeight -2 - If( lyVal, 40, 30 )      // Bottom
   DEFAULT nRight  := nWidth - 2 - 30 - nLegendWindth       // Right

   l3D     := If( nType == 3, .F., l3D )                    // POINTS
   nDeep   := If( l3D, nBarD, 1 )
   nMaxBar := nBottom - nTop - nDeep - 5
   nResH   := nResV := 1
   nWide   := ( nRight - nLeft ) * nResH / ( nMax( aData ) + 1 ) * nResH

   // Graph area
   If ! lNoBorder
      DrawWindowBoxIn( parent, Max( 1, nTop - 44 ), Max( 1, nLeft - 80 - nBarD ), nHeight - 1, nWidth - 1 )
   EndIf

   // Back area
   If l3D
      DrawRect( parent, nTop + 1, nLeft, nBottom - nDeep, nRight, WHITE, , WHITE )
   Else
      DrawRect( parent, nTop - 5, nLeft, nBottom, nRight, , , WHITE )
   EndIf

   If l3D
      // Bottom area
      For nI := 1 To nDeep + 1
          DrawLine( parent, nBottom - nI, nLeft - nDeep + nI, nBottom - nI, nRight - nDeep + nI, WHITE )
      Next nI

      // Lateral
      For nI := 1 To nDeep
          DrawLine( parent, nTop + nI, nLeft - nI, nBottom - nDeep + nI, nLeft - nI, {192, 192, 192} )
      Next nI

      // Graph borders
      For nI := 1 To nDeep + 1
          DrawLine( parent, nBottom - nI,          nLeft - nDeep + nI - 1,  nBottom - nI,          nLeft - nDeep + nI,     GRAY )
          DrawLine( parent, nBottom - nI,          nRight - nDeep + nI - 1, nBottom - nI,          nRight - nDeep + nI,    BLACK )
          DrawLine( parent, nTop + nDeep - nI + 1, nLeft - nDeep + nI - 1,  nTop + nDeep - nI + 1, nLeft - nDeep + nI,     BLACK )
          DrawLine( parent, nTop + nDeep - nI + 1, nLeft - nDeep + nI - 3,  nTop + nDeep - nI + 1, nLeft - nDeep + nI - 2, BLACK )
      Next nI

      For nI := 1 To nDeep + 2
          DrawLine( parent, nTop + nDeep - nI + 1, nLeft - nDeep + nI - 3, nTop + nDeep - nI + 1, nLeft - nDeep + nI - 2,  BLACK )
          DrawLine( parent, nBottom + 2 - nI + 1,  nRight - nDeep + nI,    nBottom + 2 - nI + 1,  nRight - nDeep + nI - 2, BLACK )
      Next nI

      DrawLine( parent, nTop,            nLeft,             nTop,                nRight,            BLACK )
      DrawLine( parent, nTop - 2,        nLeft,             nTop - 2,            nRight + 2,        BLACK )
      DrawLine( parent, nTop,            nLeft,             nBottom - nDeep,     nLeft,             GRAY  )
      DrawLine( parent, nTop + nDeep,    nLeft - nDeep,     nBottom,             nLeft - nDeep,     BLACK )
      DrawLine( parent, nTop + nDeep,    nLeft - nDeep - 2, nBottom+ 2,          nLeft - nDeep - 2, BLACK )
      DrawLine( parent, nTop,            nRight,            nBottom - nDeep,     nRight,            BLACK )
      DrawLine( parent, nTop - 2,        nRight + 2,        nBottom - nDeep + 2, nRight+ 2,         BLACK )
      DrawLine( parent, nBottom - nDeep, nLeft,             nBottom - nDeep,     nRight,            GRAY  )
      DrawLine( parent, nBottom,         nLeft - nDeep,     nBottom,             nRight - nDeep,    BLACK )
      DrawLine( parent, nBottom + 2,     nLeft - nDeep - 2, nBottom + 2,         nRight - nDeep,    BLACK )
   EndIf

   // Graph info
   If ! Empty( cTitle )
      @ nTop - 30 * nResV, nLeft LABEL Graph_Title OF &parent ;
         VALUE cTitle ;
         WIDTH nRight - nLeft + ( 50 - nLegendWindth ) ;
         HEIGHT 18 ;
         FONTCOLOR RED ;
         FONT "Arial" SIZE 12 ;
         BOLD TRANSPARENT CENTERALIGN
      aAdd( oWnd:GraphControls, "Graph_Title" )
   EndIf

   // Legends
   If lLegends
      nPos := nTop
      For nI := 1 To Len(aSeries)
         DrawBar( parent, nRight + ( 8 * nResH ), nPos + ( 9 * nResV ), 8 * nResH, 7 * nResV, l3D, 1, aColors[ nI ] )
         cName := "Ser_Name_"+lTrim( Str( nI ) )
         @ nPos, nRight + ( 20 * nResH ) LABEL &cName OF &parent ;
            VALUE aSeries[ nI ] AUTOSIZE ;
            FONTCOLOR BLACK ;
            FONT "Arial" SIZE 8 TRANSPARENT
         nPos += 18 * nResV
         aAdd( oWnd:GraphControls, cName )
      Next nI
   EndIf

   // Max, Min values
   nMax := 0
   For nJ := 1 To Len( aSeries )
      For nI :=1 To Len( aData[ nJ ] )
         nMax := Max( aData[ nJ ][ nI ], nMax )
      Next nI
   Next nJ
   nMin := 0
   For nJ := 1 To Len( aSeries )
      For nI := 1 To Len( aData[ nJ ])
         nMin := Min( aData[ nJ ][ nI ], nMin )
      Next nI
   Next nJ

   nXMax := If( nMax > 0, DetMaxVal( nMax ), 0 )
   nXMin := If( nMin < 0, DetMaxVal( nMin ), 0 )
   nHigh := nXMax + nXMin
   nMax  := Max( nXMax, nXMin )

   nRel  := ( nMaxBar / nHigh )
   nMaxBar := nMax * nRel

   nZero := nTop + (nMax * nRel) + nDeep + 5    // Zero pos
   If l3D
      For nI := 1 To nDeep + 1
          DrawLine( parent, nZero - nI + 1, nLeft - nDeep + nI, nZero - nI + 1, nRight - nDeep + nI, {192, 192, 192} )
      Next nI
      For nI := 1 To nDeep + 1
          DrawLine( parent, nZero - nI + 1, nLeft - nDeep + nI - 1,  nZero - nI + 1, nLeft - nDeep + nI,  GRAY )
          DrawLine( parent, nZero - nI + 1, nRight - nDeep + nI - 1, nZero - nI + 1, nRight - nDeep + nI, BLACK )
      Next nI
      DrawLine( parent, nZero - nDeep, nLeft, nZero - nDeep, nRight, GRAY )
   EndIf

   aPoint := Array( Len( aSeries ), Len( aData[ 1 ] ), 2 )
   nRange := nMax / nXRanges

   // xLabels
   nRPos := nRNeg := nZero - nDeep
   For nI := 0 To nXRanges
      If lxVal
         If nRange * nI <= nXMax
            cName := "xPVal_Name_" + lTrim( Str( nI ) )
            @ nRPos, nLeft - nDeep - 70 LABEL &cName OF &parent ;
               VALUE Transform( nRange * nI, cPicture ) ;
               WIDTH 60 ;
               HEIGHT 14 ;
               FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
            aAdd( oWnd:GraphControls, cName )
         EndIf
         If nRange * ( -nI ) >= nXMin * ( -1 )
            cName := "xNVal_Name_" + lTrim( Str( nI ) )
            @ nRNeg, nLeft - nDeep - 70 LABEL &cName OF &parent ;
               VALUE Transform( nRange * -nI, cPicture ) ;
               WIDTH 60 ;
               HEIGHT 14 ;
               FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
            aAdd( oWnd:GraphControls, cName )
         EndIf
      EndIf
      If lxGrid
         If nRange * nI <= nXMax
            If l3D
               For nJ := 0 To nDeep + 1
                  DrawLine( parent, nRPos + nJ, nLeft - nJ - 1, nRPos + nJ, nLeft - nJ, BLACK )
               Next nJ
            EndIf
            DrawLine( parent, nRPos, nLeft, nRPos, nRight, BLACK )
         EndIf
         If nRange *- nI >= nXMin * -1
            If l3D
               For nJ := 0 To nDeep + 1
                  DrawLine( parent, nRNeg + nJ, nLeft - nJ - 1, nRNeg + nJ, nLeft - nJ, BLACK )
               Next nJ
            EndIf
            DrawLine( parent, nRNeg, nLeft, nRNeg, nRight, BLACK )
         EndIf
      EndIf
      nRPos -= ( nMaxBar / nXRanges )
      nRNeg += ( nMaxBar / nXRanges )
   Next nI

   If lYGrid
      nPos := If( l3D, nTop, nTop - 5 )
      nI := nLeft + nWide
      For nJ := 1 To nMax( aData )
         DrawLine( parent, nBottom - nDeep, nI,         nPos,            nI, {100, 100, 100} )
         DrawLine( parent, nBottom,         nI - nDeep, nBottom - nDeep, nI, {100, 100, 100} )
         nI += nWide
      Next
   EndIf

   Do While .T.    // Bar adjust
      nPos := nLeft + ( nWide / 2 )
      nPos += ( nWide + nSep ) * ( Len( aSeries ) + 1 ) * Len(aData[ 1 ] )
      If nPos > nRight
         nWide --
      Else
         Exit
      EndIf
   EndDo

   nMin := nMax / nMaxBar
   nPos := nLeft + ( ( nWide + nSep ) / 2 )            // first point graph
//   nRange := ( ( nWide + nSep ) * Len( aSeries ) ) / 2

   If lyVal .and. Len( aYVals ) > 0                // Show yLabels
      nWideB  := ( nRight - nLeft ) / ( nMax( aData ) + 1 )
      nI := nLeft + nWideB
      For nJ := 1 To nMax( aData )
         cName := "yVal_Name_" + lTrim( Str( nJ ) )
         @ nBottom + 8, nI - nDeep - If( l3D, 0, 8 ) LABEL &cName OF &parent ;
            VALUE aYVals[ nJ ] AUTOSIZE ;
            FONTCOLOR BLUE ;
            FONT "Arial" SIZE 8 TRANSPARENT
         nI += nWideB
         aAdd( oWnd:GraphControls, cName )
      Next
   EndIf

   // Bars
   If nType == 1 .and. nMin <> 0                                 // BARS
      nPos := nLeft + ( ( nWide + nSep ) / 2 )
      For nI := 1 To Len( aData[ 1 ] )
         For nJ := 1 To Len( aSeries )
            DrawBar( parent, nPos, nZero, aData[ nJ, nI ] / nMin + nDeep, nWide, l3D, nDeep, aColors[ nJ ] )
            nPos += nWide + nSep
         Next nJ
         nPos += nWide + nSep
      Next nI
   EndIf

   // Lines
   If nType == 2 .and. nMin <> 0                                 // LINES
      nWideB := ( nRight - nLeft ) / ( nMax( aData ) + 1 )
      nPos := nLeft + nWideB
      For nI := 1 To Len( aData[ 1 ] )
         For nJ := 1 To Len( aSeries )
            If ! l3D
               DrawPoint( parent, nType, nPos, nZero, aData[ nJ, nI ] / nMin + nDeep, aColors[ nJ ] )
            EndIf
            aPoint[ nJ, nI, 2 ] := nPos
            aPoint[ nJ, nI, 1 ] := nZero - ( aData[ nJ, nI ] / nMin + nDeep )
         Next nJ
         nPos += nWideB
      Next nI

      For nI := 1 To Len( aData[ 1 ] ) - 1
         For nJ := 1 To Len( aSeries )
            If l3D
               DrawPolygon( parent, {{aPoint[ nJ, nI, 1 ], aPoint[ nJ, nI, 2 ]}, {aPoint[ nJ, nI + 1, 1 ], aPoint[ nJ, nI + 1, 2 ]}, ;
                            {aPoint[ nJ, nI + 1, 1] - nDeep, aPoint[ nJ, nI + 1, 2 ] + nDeep}, {aPoint[ nJ, nI, 1 ] - nDeep, aPoint[ nJ, nI, 2 ] + nDeep}, ;
                            {aPoint[ nJ, nI, 1 ], aPoint[ nJ, nI, 2 ]}}, , , aColors[ nJ ] )
            Else
               DrawLine( parent, aPoint[ nJ, nI, 1 ], aPoint[ nJ, nI, 2 ], aPoint[ nJ, nI + 1, 1 ], aPoint[ nJ, nI + 1, 2 ], aColors[ nJ ] )
            EndIf
         Next nI
      Next nI
   EndIf

   // Points
   If nType == 3 .and. nMin <> 0                                // POINTS
      nWideB := ( nRight - nLeft ) / ( nMax( aData ) + 1 )
      nPos := nLeft + nWideB
      For nI := 1 To Len( aData[ 1 ] )
         For nJ=1 To Len( aSeries )
            DrawPoint( parent, nType, nPos, nZero, aData[ nJ, nI ] / nMin + nDeep, aColors[ nJ ] )
            aPoint[ nJ, nI, 2 ] := nPos
            aPoint[ nJ, nI, 1 ] := nZero - aData[ nJ, nI ] / nMin
         Next nJ
         nPos += nWideB
      Next nI
   EndIf

   If lViewVal
      If nType == 1                                         // BARS
         nPos := nLeft + nWide + ( ( nWide + nSep ) * ( Len( aSeries ) / 2 ) )
      Else
         nWideB := ( nRight - nLeft ) / ( nMax( aData ) + 1 )
         nPos := nLeft + nWideB
      EndIf
      For nI := 1 To Len( aData[ 1 ] )
         For nJ := 1 To Len( aSeries )
            cName := "Data_Name_" + lTrim( Str( nI ) ) + lTrim( Str( nJ ) )
            @ nZero - ( aData[ nJ, nI ] / nMin + nDeep ), If( nType == 1, nPos - If( l3D, 8, 10 ), nPos + 10 ) ;       // BARS
               LABEL &cName OF &parent ;
               VALUE Transform( aData[ nJ, nI ], cPicture ) AUTOSIZE ;
               FONT "Arial" SIZE 8 BOLD TRANSPARENT
            nPos += If( nType == 1, nWide + nSep, 0 )                  // BARS
            aAdd( oWnd:GraphControls, cName )
         Next nJ
         If nType == 1                                              // BARS
            nPos += nWide + nSep
         Else
            nPos += nWideB
         EndIf
      Next nI
   EndIf

   If l3D
      DrawLine( parent, nZero, nLeft - nDeep, nZero, nRight - nDeep, BLACK )
   Else
      If nXMax <> 0 .and. nXMin <> 0
         DrawLine( parent, nZero - 1, nLeft - 2, nZero - 1, nRight, RED )
      EndIf
   EndIf
Return


Static Procedure DrawBar( parent, nY, nX, nHigh, nWidth, l3D, nDeep, aColor )
Local nI, nColTop, nShadow, nH := nHigh

   nColTop := ClrShadow( RGB( aColor[ 1 ], aColor[ 2 ], aColor[ 3 ] ), 15 )
   nShadow := ClrShadow( nColTop, 15 )
   nColTop := {GetRed( nColTop ), GetGreen( nColTop ), GetBlue( nColTop )}
   nShadow := {GetRed( nShadow ), GetGreen( nShadow ), GetBlue( nShadow )}

   For nI := 1 To nWidth
      DrawLine( parent, nX, nY + nI, nX + nDeep - nHigh, nY + nI, aColor )  // front
   Next nI

   If l3D
      // Lateral
      DrawPolygon( parent, {{nX - 1, nY + nWidth + 1}, {nX + nDeep - nHigh, nY + nWidth + 1}, ;
                   {nX - nHigh + 1, nY + nWidth + nDeep}, {nX - nDeep, nY + nWidth + nDeep}, ;
                   {nX - 1, nY + nWidth + 1}}, nShadow, , nShadow )
      // Superior
      nHigh   := Max( nHigh, nDeep )
      DrawPolygon( parent, {{nX - nHigh + nDeep, nY + 1}, {nX - nHigh + nDeep, nY + nWidth + 1}, ;
                   {nX - nHigh + 1, nY + nWidth + nDeep}, {nX - nHigh + 1, nY + nDeep}, ;
                   {nX - nHigh + nDeep, nY + 1}}, nColTop, , nColTop )
      // Border
      DrawBox( parent, nY, nX, nH, nWidth, l3D, nDeep )
   EndIf
Return


Static Procedure DrawBox( parent, nY, nX, nHigh, nWidth, l3D, nDeep )
   // Set Border
   DrawLine( parent, nX,                 nY,          nX - nHigh + nDeep, nY,          BLACK )  // Left
   DrawLine( parent, nX,                 nY + nWidth, nX - nHigh + nDeep, nY + nWidth, BLACK )  // Right
   DrawLine( parent, nX - nHigh + nDeep, nY,          nX - nHigh + nDeep, nY + nWidth, BLACK )  // Top
   DrawLine( parent, nX,                 nY,          nX,                 nY + nWidth, BLACK )  // Bottom
   If l3D
      // Set shadow
      DrawLine( parent, nX - nHigh + nDeep, nY + nWidth, nX - nHigh, nY + nDeep + nWidth, BLACK )
      DrawLine( parent, nX,                 nY + nWidth, nX - nDeep, nY + nWidth + nDeep, BLACK )
      If nHigh > 0
         DrawLine( parent, nX - nDeep,         nY + nWidth + nDeep, nX - nHigh, nY + nWidth + nDeep, BLACK )
         DrawLine( parent, nX - nHigh,         nY + nDeep,          nX - nHigh, nY + nWidth + nDeep, BLACK )
         DrawLine( parent, nX - nHigh + nDeep, nY,                  nX - nHigh, nY + nDeep,          BLACK )
      Else
         DrawLine( parent, nX - nDeep, nY + nWidth + nDeep, nX - nHigh + 1, nY + nWidth + nDeep, BLACK )
         DrawLine( parent, nX,         nY,                  nX - nDeep,     nY + nDeep,          BLACK )
      EndIf
   EndIf
Return


Static Procedure DrawPoint( parent, nType, nY, nX, nHigh, aColor )
   If nType == 3                      // POINTS
      Circle( parent, nX - nHigh - 3, nY - 3, 8, aColor )
   ElseIf nType == 2                  // LINES
      Circle( parent, nX - nHigh - 2, nY - 2, 6, aColor )
   EndIf
Return


Static Procedure Circle( window, nCol, nRow, nWidth, aColor )
   DrawEllipse( window, nCol, nRow, nCol + nWidth - 1, nRow + nWidth - 1, , , aColor )
Return


Static Function nMax( aData )
   Local nI, nMax := 0

   For nI := 1 To Len( aData )
      nMax := Max( Len( aData[ nI ] ), nMax )
   Next nI
Return nMax


Static Function DetMaxVal( nNum )
   Local nE, nMax, nMan, nVal, nOffset

   nE := 9
   nVal := 0
   nNum := Abs( nNum )

   Do While .T.
      nMax := 10 ** nE

      If Int( nNum / nMax ) > 0
         nMan := ( nNum / nMax ) - Int( nNum / nMax )
         nOffset := 1
         nOffset := If( nMan <= .75, .75, nOffset )
         nOffset := If( nMan <= .50, .50, nOffset )
         nOffset := If( nMan <= .25, .25, nOffset )
         nOffset := If( nMan <= .00, .00, nOffset )
         nVal := ( Int( nNum / nMax ) + nOffset ) * nMax
         Exit
      EndIf

      nE --
   EndDo
Return nVal


Static Function ClrShadow( nColor, nFactor )
   Local aHSL, aRGB

   aHSL := RGB2HSL( GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) )
   aHSL[ 3 ] -= nFactor
   aRGB := HSL2RGB( aHSL[ 1 ], aHSL[ 2 ], aHSL[ 3 ] )
Return RGB( aRGB[ 1 ], aRGB[ 2 ], aRGB[ 3 ] )


Static Function RGB2HSL( nR, nG, nB )
   Local nMax, nMin
   Local nH, nS, nL

   If nR < 0
      nR := Abs( nR )
      nG := GetGreen( nR )
      nB := GetBlue( nR )
      nR := GetRed( nR )
   EndIf

   nR := nR / 255
   nG := nG / 255
   nB := nB / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nL := ( nMax + nMin ) / 2

   If nMax == nMin
      nH := 0
      nS := 0
   Else
      If nL < 0.5
         nS := ( nMax - nMin ) / ( nMax + nMin )
      Else
         nS := ( nMax - nMin ) / ( 2.0 - nMax - nMin )
      EndIf
      Do Case
      Case nR == nMax
         nH := ( nG - nB ) / ( nMax - nMin )
      Case nG == nMax
         nH := 2.0 + ( nB - nR ) / ( nMax - nMin )
      Case nB == nMax
         nH := 4.0 + ( nR - nG ) / ( nMax - nMin )
      EndCase
   EndIf

   nH := Int( (nH * 239) / 6 )
   If nH < 0
      nH += 240
   EndIf
   nS := Int( nS * 239 )
   nL := Int( nL * 239 )
Return { nH, nS, nL }


Static Function HSL2RGB( nH, nS, nL )
Local nFor
Local nR, nG, nB
Local nTmp1, nTmp2, aTmp3 := { 0, 0, 0 }

   nH /= 239
   nS /= 239
   nL /= 239
   If nS == 0
      nR := nL
      nG := nL
      nB := nL
   Else
      If nL < 0.5
         nTmp2 := nL * ( 1 + nS )
      Else
         nTmp2 := nL + nS - ( nL * nS )
      EndIf
      nTmp1 := 2 * nL - nTmp2
      aTmp3[1] := nH + 1 / 3
      aTmp3[2] := nH
      aTmp3[3] := nH - 1 / 3
      For nFor := 1 To 3
         If aTmp3[ nFor ] < 0
            aTmp3[ nFor ] += 1
         EndIf
         If aTmp3[ nFor ] > 1
            aTmp3[ nFor ] -= 1
         EndIf
         If 6 * aTmp3[ nFor ] < 1
            aTmp3[ nFor ] := nTmp1 + ( nTmp2 - nTmp1 ) * 6 * aTmp3[ nFor ]
         Else
            If 2 * aTmp3[ nFor ] < 1
               aTmp3[ nFor ] := nTmp2
            Else
               If 3 * aTmp3[ nFor ] < 2
                  aTmp3[ nFor ] := nTmp1 + ( nTmp2 - nTmp1 ) * ( ( 2 / 3 ) - aTmp3[ nFor ] ) * 6
               Else
                  aTmp3[ nFor ] := nTmp1
               EndIf
            EndIf
         EndIf
      Next nFor
      nR := aTmp3[ 1 ]
      nG := aTmp3[ 2 ]
      nB := aTmp3[ 3 ]
   EndIf
Return { Int( nR * 255 ), Int( nG * 255 ), Int( nB * 255 ) }


Function DrawWindowBoxIn( window, row, col, rowr, colr )
Local oWnd := GetFormObject( window )

/*
   WndBoxInDraw( oWnd:hWnd, row, col, rowr, colr )
   aAdd ( oWnd:GraphTasks, { || WndBoxInDraw( oWnd:hWnd, row, col, rowr, colr ) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 7, row, col, rowr, colr ) )
Return Nil


Function DrawWindowBoxRaised( window, row, col, rowr, colr )
Local oWnd := GetFormObject( window )

/*
   WndBoxRaisedDraw( oWnd:hWnd, row, col, rowr, colr )
   aAdd ( oWnd:GraphTasks, { || WndBoxRaisedDraw( oWnd:hWnd, row, col, rowr, colr ) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aAdd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 11, row, col, rowr, colr ) )
Return Nil


Function DrawPieGraph( window, fromrow, fromcol, torow, tocol, series, aname, colors, ctitle, depth, l3d, lxval, lsleg, lnoborder )
Local topleftrow // := fromrow
Local topleftcol // := fromcol
Local toprightrow // := fromrow
Local toprightcol // := tocol
Local bottomrightrow // := torow
Local bottomrightcol // := tocol
Local bottomleftrow // := torow
Local bottomleftcol // := fromcol
// Local middletoprow := fromrow
Local middletopcol // := fromcol + int(tocol - fromcol) / 2
Local middleleftrow // := fromrow + int(torow - fromrow) / 2
Local middleleftcol // := fromcol
// Local middlebottomrow := torow
Local middlebottomcol // := fromcol + int(tocol - fromcol) / 2
Local middlerightrow // := fromrow + int(torow - fromrow) / 2
Local middlerightcol // := tocol
Local fromradialrow // := 0
Local fromradialcol // := 0
Local toradialrow // := 0
Local toradialcol // := 0
Local degrees := {}
Local cumulative := {}
Local j, i, sum := 0
Local cname // := ""
Local shadowcolor // := {}
Local nPos
Local oWnd := GetFormObject( window )

   If ! lNoBorder
      DrawLine( window, torow,       fromcol,     torow,       tocol,       WHITE )
      DrawLine( window, torow  - 1,  fromcol + 1, torow - 1,   tocol - 1,   GRAY  )
      DrawLine( window, torow  - 1,  fromcol,     fromrow,     fromcol,     GRAY  )
      DrawLine( window, torow  - 2,  fromcol + 1, fromrow + 1, fromcol + 1, GRAY  )
      DrawLine( window, fromrow,     fromcol,     fromrow,     tocol - 1,   GRAY  )
      DrawLine( window, fromrow + 1, fromcol + 1, fromrow + 1, tocol - 2,   GRAY  )
      DrawLine( window, fromrow,     tocol,       torow,       tocol,       WHITE )
      DrawLine( window, fromrow,     tocol - 1,   torow - 1,   tocol - 1,   GRAY  )
   EndIf

   If Len( AllTrim( ctitle ) ) > 0
      If _IsControlDefined("title_of_pie", window)
         DoMethod( window, "title_of_pie", "Release" )
      EndIf
      If ( nPos := aScan( oWnd:GraphControls, "title_of_pie" ) ) > 0
         aDel( oWnd:GraphControls, nPos )
         aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
      EndIf
      DEFINE LABEL title_of_pie
         PARENT &window
         ROW fromrow + 10
         COL If( Len( AllTrim( ctitle ) ) * 12 > ( tocol - fromcol ), fromcol, int( ( ( tocol - fromcol ) - ( Len( AllTrim( ctitle ) ) * 12 ) ) / 2 ) + fromcol )
         AUTOSIZE .T.
         FONTCOLOR {0, 0, 255}
         FONTBOLD .T.
         FONTNAME "Arial"
         FONTUNDERLINE .T.
         FONTSIZE 12
         VALUE AllTrim( ctitle )
         TRANSPARENT .T.
      END LABEL
      aAdd( oWnd:GraphControls, "title_of_pie" )
      fromrow := fromrow + 40
   EndIf

   If lsleg
      If Len( aname ) * 20 > ( torow - fromrow )
         MsgInfo( "No space for showing legends !!!" )
      Else
         torow := torow - ( Len( aname ) * 20 )
      EndIf
   EndIf

   DrawRect( window, fromrow + 10, fromcol + 10, torow - 10, tocol - 10, {0, 0, 0}, 1, {255, 255, 255} )

   If l3d
      torow := torow - depth
   EndIf

   fromcol := fromcol + 25
   tocol := tocol - 25
   torow := torow - 25
   fromrow := fromrow + 25

   topleftrow := fromrow
   topleftcol := fromcol
   toprightrow := fromrow
   toprightcol := tocol
   bottomrightrow := torow
   bottomrightcol := tocol
   bottomleftrow := torow
   bottomleftcol := fromcol
   // middletoprow := fromrow
   middletopcol := fromcol + int( tocol - fromcol ) / 2
   middleleftrow := fromrow + int( torow - fromrow ) / 2
   middleleftcol := fromcol
   // middlebottomrow := torow
   middlebottomcol := fromcol + int( tocol - fromcol ) / 2
   middlerightrow := fromrow + int( torow - fromrow ) / 2
   middlerightcol := tocol

   torow := torow + 1
   tocol := tocol + 1

   For i := 1 To Len( series )
      sum := sum + series[ i ]
   Next i
   For i := 1 To Len( series )
      aAdd( degrees, Round( series[ i ] / sum * 360, 0 ) )
   Next i
   sum := 0
   For i := 1 To Len( degrees )
      sum := sum + degrees[ i ]
   Next i
   If sum <> 360
      degrees[ Len( degrees ) ] := degrees[ Len( degrees ) ] + ( 360 - sum )
   EndIf

   sum := 0
   For i := 1 To Len( degrees )
      sum := sum + degrees[ i ]
      aAdd( cumulative, sum )
   Next i

   fromradialrow := middlerightrow
   fromradialcol := middlerightcol
   For i := 1 To Len( cumulative )
      shadowcolor := {If( colors[ i, 1 ] > 50, colors[ i, 1 ] - 50, 0 ), If( colors[ i, 2 ] > 50, colors[ i, 2 ] - 50, 0 ), If( colors[ i, 3 ] > 50, colors[ i, 3 ] - 50, 0 )}
      Do Case
      Case cumulative[ i ] <= 45
         toradialcol := middlerightcol
         toradialrow := middlerightrow - Round( cumulative[ i ] / 45 * ( middlerightrow - toprightrow ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 90 .and. cumulative[ i ] > 45
         toradialrow := toprightrow
         toradialcol := toprightcol - Round( ( cumulative[ i ] - 45 ) / 45 * ( toprightcol - middletopcol ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 135 .and. cumulative[ i ] > 90
         toradialrow := topleftrow
         toradialcol := middletopcol - Round( ( cumulative[ i ] - 90 ) / 45 * ( middletopcol - topleftcol ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 180 .and. cumulative[ i ] > 135
         toradialcol := topleftcol
         toradialrow := topleftrow + Round( ( cumulative[ i ] - 135 ) / 45 * ( middleleftrow - topleftrow ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         Endif
      Case cumulative[ i ] <= 225 .and. cumulative[ i ] > 180
         toradialcol := topleftcol
         toradialrow := middleleftrow + Round( ( cumulative[ i ] - 180 ) / 45 * ( bottomleftrow - middleleftrow ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            If l3d
               For j := 1 To depth
                  DrawArc( window, fromrow + j, fromcol, torow + j, tocol, fromradialrow + j, fromradialcol, toradialrow + j, toradialcol, shadowcolor )
               Next j
            EndIf
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 270 .and. cumulative[ i ] > 225
         toradialrow := bottomleftrow
         toradialcol := bottomleftcol + Round( ( cumulative[ i ] - 225 ) / 45 * ( middlebottomcol - bottomleftcol ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            If l3d
               For j := 1 To depth
                  DrawArc( window, fromrow + j, fromcol, torow + j, tocol, fromradialrow + j, fromradialcol, toradialrow + j, toradialcol, shadowcolor )
               Next j
            EndIf
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 315 .and. cumulative[ i ] > 270
         toradialrow := bottomleftrow
         toradialcol := middlebottomcol + Round( ( cumulative[ i ] - 270 ) / 45 * ( bottomrightcol - middlebottomcol ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            If l3d
               For j := 1 To depth
                  DrawArc( window, fromrow + j, fromcol, torow + j, tocol, fromradialrow + j, fromradialcol, toradialrow + j, toradialcol, shadowcolor )
               Next j
            EndIf
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      Case cumulative[ i ] <= 360 .and. cumulative[ i ] > 315
         toradialcol := bottomrightcol
         toradialrow := bottomrightrow - round( ( cumulative[ i ] - 315 ) / 45 * ( bottomrightrow - middlerightrow ), 0 )
         If fromradialrow # toradialrow .OR. fromradialcol # toradialcol
            If l3d
               For j := 1 To depth
                  DrawArc( window, fromrow + j, fromcol, torow + j, tocol, fromradialrow + j, fromradialcol, toradialrow + j, toradialcol, shadowcolor )
               Next j
            EndIf
            DrawPie( window, fromrow, fromcol, torow, tocol, fromradialrow, fromradialcol, toradialrow, toradialcol, , , colors[ i ] )
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         EndIf
      EndCase
      If l3d
         DrawLine( window, middleleftrow, middleleftcol, middleleftrow + depth, middleleftcol )
         DrawLine( window, middlerightrow, middlerightcol, middlerightrow + depth, middlerightcol )
         DrawArc( window, fromrow + depth, fromcol, torow + depth, tocol, middleleftrow + depth, middleleftcol, middlerightrow + depth, middlerightcol )
      EndIf
   Next i
   If lsleg
      fromrow := torow + 20 + If( l3d, depth, 0 )
      For i := 1 To Len( aname )
         cname := "pielegend_" + AllTrim( Str( i, 3, 0 ) )
         If _IsControlDefined( cname, window )
            DoMethod( window, cname, "Release" )
         EndIf
         If ( nPos := aScan( oWnd:GraphControls, cname ) ) > 0
            aDel( oWnd:GraphControls, nPos )
            aSize( oWnd:GraphControls, Len( oWnd:GraphControls ) - 1 )
         EndIf
         DrawRect( window, fromrow, fromcol, fromrow + 15, fromcol + 15, {0, 0, 0}, 1, colors[ i ] )
         DEFINE LABEL &cname
            PARENT &window
            ROW fromrow
            COL fromcol + 20
            FONTNAME "Arial"
            FONTSIZE 8
            AUTOSIZE .T.
            VALUE aname[ i ] + If( lxval, " - " + AllTrim( Str( series[ i ], 10, 2 ) ) + " (" + AllTrim( Str( degrees[ i ] / 360 * 100, 6, 2 ) ) + " %)", "" )
            FONTCOLOR colors[ i ]
            TRANSPARENT .T.
         END LABEL
         aAdd( oWnd:GraphControls, cname )
         fromrow := fromrow + 20
      Next i
   EndIf
Return Nil
