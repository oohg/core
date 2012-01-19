/*
 * $Id: h_graph.prg,v 1.7 2012-01-19 18:31:18 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG graphic functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
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
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#include "oohg.ch"

function drawtextout(window,row,col,string,fontcolor,backcolor,fontname,fontsize,bold,italic,underline,strikeout,transparent)
Local oWnd, oControl
Local row1, col1

   oControl := TControl()
   oControl:SetForm( , window, FontName, FontSize, FontColor, BackColor )
   oWnd := oControl:Parent

   if oWnd:hWnd > 0

      oControl:SetFont( ,, bold, italic, underline, strikeout )
      col1 := col + GetTextWidth(  0, string, oControl:FontHandle )
      row1 := row + GetTextHeight( 0, string, oControl:FontHandle )
      DeleteObject( oControl:FontHandle )

      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aadd( oWnd:GraphData, _OOHG_NewGraphCommand_Text( oWnd:hWnd, 0, row, col, row1, col1, oControl:FontColor, string, oControl:BackColor, transparent, bold, italic, underline, strikeout, oControl:fontname, oControl:fontsize ) )

	endif

return nil

function drawline(window,row,col,row1,col1,penrgb,penwidth)
Local oWnd := GetFormObject( Window )

   if oWnd:hWnd > 0

		if valtype(penrgb) == "U"
			penrgb = {0,0,0}
		endif

		if valtype(penwidth) == "U"
			penwidth = 1
		endif

/*
      linedraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth)

      aadd ( oWnd:GraphTasks, { || linedraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth) } )
*/
      oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
      aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 1, row, col, row1, col1, penrgb, penwidth ) )

	endif

return nil

function drawrect(window,row,col,row1,col1,penrgb,penwidth,fillrgb)
Local oWnd := GetFormObject( Window )
Local fill

if oWnd:hWnd > 0

   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif

   if valtype(penwidth) == "U"
      penwidth = 1
   endif

   if valtype(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif

/*
   rectdraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth,fillrgb,fill)

   aadd ( oWnd:GraphTasks, { || rectdraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth,fillrgb,fill) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 2, row, col, row1, col1, penrgb, penwidth, fillrgb, fill ) )

endif
return nil

function drawroundrect(window,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb)
Local oWnd := GetFormObject( Window )
Local fill

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
   if valtype(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
/*
   roundrectdraw( oWnd:hWnd,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb,fill)

   aadd ( oWnd:GraphTasks, { || roundrectdraw( oWnd:hWnd,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb,fill) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 3, row, col, row1, col1, penrgb, penwidth, fillrgb, fill,,,,, width, height ) )

endif
return nil

function drawellipse(window,row,col,row1,col1,penrgb,penwidth,fillrgb)
Local oWnd := GetFormObject( Window )
Local fill

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
   if valtype(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
/*
   ellipsedraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth,fillrgb,fill)

   aadd ( oWnd:GraphTasks, { || ellipsedraw( oWnd:hWnd,row,col,row1,col1,penrgb,penwidth,fillrgb,fill) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 4, row, col, row1, col1, penrgb, penwidth, fillrgb, fill ) )

endif
return nil

function drawarc(window,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth)
Local oWnd := GetFormObject( Window )

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
/*
   arcdraw( oWnd:hWnd,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth)
   aadd ( oWnd:GraphTasks, { || arcdraw( oWnd:hWnd,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 5, row, col, row1, col1, penrgb, penwidth,,, rowr, colr, rowr1, colr1 ) )

endif

return nil

function drawpie(window,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb)
Local oWnd := GetFormObject( Window )
Local fill

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
   if valtype(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
/*
   piedraw( oWnd:hWnd,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb,fill)

   aadd ( oWnd:GraphTasks, { || piedraw( oWnd:hWnd,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb,fill) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 6, row, col, row1, col1, penrgb, penwidth, fillrgb, fill, rowr, colr, rowr1, colr1 ) )

endif
return nil

function drawpolygon(window,apoints,penrgb,penwidth,fillrgb)
Local oWnd := GetFormObject( Window )
Local fill
local xarr
local yarr

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
   if valtype(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
   xarr := array( len( apoints ) )
   yarr := array( len( apoints ) )
   aeval( apoints, { |a,i| yarr[ i ] := a[ 1 ], xarr[ i ] := a[ 2 ] } )
/*
   polygondraw(oWnd:hWnd,xarr,yarr,penrgb,penwidth,fillrgb,fill)
   aadd( oWnd:GraphTasks, {||polygondraw(oWnd:hWnd,xarr,yarr,penrgb,penwidth,fillrgb,fill)})
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 8, yarr, xarr,,, penrgb, penwidth, fillrgb, fill ) )
endif
return nil

function drawpolybezier(window,apoints,penrgb,penwidth)
Local oWnd := GetFormObject( Window )
local xarr
local yarr

if oWnd:hWnd > 0
   if valtype(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if valtype(penwidth) == "U"
      penwidth = 1
   endif
   xarr := array( len( apoints ) )
   yarr := array( len( apoints ) )
   aeval( apoints, { |a,i| yarr[ i ] := a[ 1 ], xarr[ i ] := a[ 2 ] } )
/*
   polybezierdraw(oWnd:hWnd,xarr,yarr,penrgb,penwidth)
   aadd( oWnd:GraphTasks, {||polybezierdraw(oWnd:hWnd,xarr,yarr,penrgb,penwidth)})
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 9, yarr, xarr,,, penrgb, penwidth ) )
endif
return nil

function erasewindow(window)
Local oWnd := GetFormObject( Window )

   if oWnd:hWnd > 0

            aSize( oWnd:GraphTasks, 0 )
            aSize( oWnd:GraphData, 0 )
            oWnd:GraphCommand := nil
            redrawwindow( oWnd:hWnd )

	endif

return nil

 * Copyright Alfredo Arteaga 14/10/2001 original idea
 *
 * Grigory Filatov 23/06/2003 translation for MiniGUI
 *
 * Roberto Lopez 23/06/2003 command definition
 *
 * Copyright Alfredo Arteaga TGRAPH 2, 12/03/2002
 *
 * Grigory Filatov 26/02/2004 translation #2 for MiniGUI

Procedure GraphShow(parent,nTop,nLeft,nBottom,nRight,nHeight,nWidth,aData,cTitle,aYVals,nBarD,nWideB,nSep,nXRanges,;
   l3D,lGrid,lxGrid,lyGrid,lxVal,lyVal,lLegends,aSeries,aColors,nType,lViewVal,cPicture, nLegendWindth, lNoborder )
   LOCAL nI, nJ, nPos, nMax, nMin, nMaxBar, nDeep
   LOCAL nRange, nResH, nResV,  nWide, aPoint, cName
   LOCAL nXMax, nXMin, nHigh, nRel, nZero, nRPos, nRNeg

   DEFAULT cTitle   := ""
   DEFAULT nSep     := 0
   DEFAULT cPicture := "999,999.99"
   DEFAULT nLegendWindth := 50
   DEFAULT lNoborder := .F.

   If ! lLegends
      nLegendWindth := 0
   EndIf

	If 	( Len (aSeries) != Len (aData) ) .or. ;
		( Len (aSeries) != Len (aColors) )

      MsgOOHGError("DRAW GRAPH: 'Series' / 'SerieNames' / 'Colors' arrays size mismatch. Program terminated","MiniGUI Error")
	EndIf

	If _IsControlDefined ( 'Graph_Title', Parent )
      DoMethod( Parent, "Graph_Title", "Release" )
	EndIf

	For ni := 1 To Len(aSeries)
		cName := "Ser_Name_"+ltrim(str(ni))
		If _IsControlDefined ( cName, Parent )
         DoMethod( Parent, cName, "Release" )
		EndIf
	Next

	For ni := 0 To nXRanges
		cName := "xPVal_Name_"+ltrim(str(ni))
		If _IsControlDefined ( cName, Parent )
         DoMethod( Parent, cName, "Release" )
		EndIf
	Next

	For ni := 0 To nXRanges
		cName := "xNVal_Name_"+ltrim(str(ni))
		If _IsControlDefined ( cName, Parent )
         DoMethod( Parent, cName, "Release" )
		EndIf
	Next

	For ni := 1 To nMax(aData)
		cName := "yVal_Name_"+ltrim(str(ni))
		If _IsControlDefined ( cName, Parent )
         DoMethod( Parent, cName, "Release" )
		EndIf
	Next

	FOR nI := 1 TO Len(aData[1])
		FOR nJ := 1 TO Len(aSeries)
			cName := "Data_Name_"+Ltrim(Str(nI))+Ltrim(Str(nJ))
			If _IsControlDefined ( cName, Parent )
            DoMethod( Parent, cName, "Release" )
			EndIf
		Next nJ
	Next nI

   IF lGrid
      lxGrid := lyGrid := .T.
   ENDIF
   IF nBottom <> NIL .AND. nRight <> NIL
      nHeight := nBottom - nTop / 2
      nWidth  := nRight - nLeft / 2
      nBottom -= IF(lyVal, 42, 32)
      nRight  -= 32 + nLegendWindth
   ENDIF
   nTop    += 1 + IF(Empty(cTitle), 30, 44)             // Top gap
   nLeft   += 1 + IF(lxVal, 80 + nBarD, 30 + nBarD)     // Left
   DEFAULT nBottom := nHeight -2 - IF(lyVal, 40, 30)    // Bottom
   DEFAULT nRight  := nWidth - 2 - 30 - nLegendWindth   // Right

   l3D     := IF( nType == POINTS, .F., l3D )
   nDeep   := IF( l3D, nBarD, 1 )
   nMaxBar := nBottom - nTop - nDeep - 5
   nResH   := nResV := 1
   nWide   := ( nRight - nLeft )*nResH / ( nMax(aData) + 1 ) * nResH

   // Graph area
   If ! lNoBorder
      DrawWindowBoxIn( parent, Max(1,nTop-44), Max(1,nLeft-80-nBarD), nHeight-1, nWidth-1 )
   EndIf

   // Back area
   //
   IF l3D
      drawrect( parent, nTop+1, nLeft, nBottom-nDeep, nRight, WHITE, , WHITE )
   ELSE
      drawrect( parent, nTop-5, nLeft, nBottom, nRight, , , WHITE )
   ENDIF

   IF l3D
         // Bottom area
         FOR nI := 1 TO nDeep+1
             DrawLine( parent, nBottom-nI, nLeft-nDeep+nI, nBottom-nI, nRight-nDeep+nI, WHITE )
         NEXT nI

         // Lateral
         FOR nI := 1 TO nDeep
             DrawLine( parent, nTop+nI, nLeft-nI, nBottom-nDeep+nI, nLeft-nI, {192, 192, 192} )
         NEXT nI

         // Graph borders
         FOR nI := 1 TO nDeep+1
             DrawLine( parent, nBottom-nI     ,nLeft-nDeep+nI-1 ,nBottom-nI     ,nLeft-nDeep+nI  ,GRAY )
             DrawLine( parent, nBottom-nI     ,nRight-nDeep+nI-1,nBottom-nI     ,nRight-nDeep+nI ,BLACK )
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-1 ,nTop+nDeep-nI+1,nLeft-nDeep+nI  ,BLACK )
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-3 ,nTop+nDeep-nI+1,nLeft-nDeep+nI-2,BLACK )
         NEXT nI

         FOR nI=1 TO nDeep+2
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-3,nTop+nDeep-nI+1,nLeft-nDeep+nI-2 ,BLACK )
             DrawLine( parent, nBottom+ 2-nI+1,nRight-nDeep+nI ,nBottom+ 2-nI+1,nRight-nDeep+nI-2,BLACK )
         NEXT nI

         DrawLine( parent, nTop         ,nLeft        ,nTop           ,nRight       ,BLACK )
         DrawLine( parent, nTop- 2      ,nLeft        ,nTop- 2        ,nRight+ 2    ,BLACK )
         DrawLine( parent, nTop         ,nLeft        ,nBottom-nDeep  ,nLeft        ,GRAY  )
         DrawLine( parent, nTop+nDeep   ,nLeft-nDeep  ,nBottom        ,nLeft-nDeep  ,BLACK )
         DrawLine( parent, nTop+nDeep   ,nLeft-nDeep-2,nBottom+ 2     ,nLeft-nDeep-2,BLACK )
         DrawLine( parent, nTop         ,nRight       ,nBottom-nDeep  ,nRight       ,BLACK )
         DrawLine( parent, nTop- 2      ,nRight+ 2    ,nBottom-nDeep+2,nRight+ 2    ,BLACK )
         DrawLine( parent, nBottom-nDeep,nLeft        ,nBottom-nDeep  ,nRight       ,GRAY  )
         DrawLine( parent, nBottom      ,nLeft-nDeep  ,nBottom        ,nRight-nDeep ,BLACK )
         DrawLine( parent, nBottom+ 2   ,nLeft-nDeep-2,nBottom+ 2     ,nRight-nDeep ,BLACK )
   ENDIF

   // Graph info
   //
   IF !Empty(cTitle)
      @ nTop-30*nResV, nLeft LABEL Graph_Title OF &parent ;
		VALUE cTitle ;
      WIDTH nRight - nLeft + ( 50 - nLegendWindth ) ;
		HEIGHT 18 ;
		FONTCOLOR RED ;
		FONT "Arial" SIZE 12 ;
      BOLD TRANSPARENT CENTERALIGN
   ENDIF

   // Legends
   //
   IF lLegends
      nPos := nTop
      FOR nI := 1 TO Len(aSeries)
         DrawBar( parent, nRight+(8*nResH), nPos+(9*nResV), 8*nResH, 7*nResV, l3D, 1, aColors[nI] )
         cName := "Ser_Name_"+Ltrim( Str( nI ) )
         @ nPos, nRight+(20*nResH) LABEL &cName OF &parent ;
                 VALUE aSeries[nI] AUTOSIZE ;
                 FONTCOLOR BLACK ;
                 FONT "Arial" SIZE 8 TRANSPARENT
         nPos += 18*nResV
      NEXT nI
   ENDIF

   // Max, Min values
   nMax := 0
   FOR nJ := 1 TO Len(aSeries)
      FOR nI :=1 TO Len(aData[nJ])
         nMax := Max( aData[nJ][nI], nMax )
      NEXT nI
   NEXT nJ
   nMin := 0
   FOR nJ := 1 TO Len(aSeries)
      FOR nI :=1 TO Len(aData[nJ])
         nMin := Min( aData[nJ][nI], nMin )
      NEXT nI
   NEXT nJ

   nXMax := IF( nMax > 0, DetMaxVal( nMax ), 0 )
   nXMin := IF( nMin < 0, DetMaxVal( nMin ), 0 )
   nHigh := nXMax + nXMin
   nMax  := Max( nXMax, nXMin )

   nRel  := ( nMaxBar / nHigh )
   nMaxBar := nMax * nRel

   nZero := nTop + (nMax*nRel) + nDeep + 5    // Zero pos
   IF l3D
      FOR nI := 1 TO nDeep+1
          DrawLine( parent, nZero-nI+1, nLeft-nDeep+nI   , nZero-nI+1, nRight-nDeep+nI, {192, 192, 192} )
      NEXT nI
      FOR nI := 1 TO nDeep+1
          DrawLine( parent, nZero-nI+1, nLeft-nDeep+nI-1 , nZero-nI+1, nLeft -nDeep+nI, GRAY )
          DrawLine( parent, nZero-nI+1, nRight-nDeep+nI-1, nZero-nI+1, nRight-nDeep+nI, BLACK )
      NEXT nI
      DrawLine( parent, nZero-nDeep, nLeft, nZero-nDeep, nRight, GRAY )
   ENDIF

   aPoint := Array( Len( aSeries ), Len( aData[1] ), 2 )
   nRange := nMax / nXRanges

   // xLabels
   nRPos := nRNeg := nZero - nDeep
   FOR nI := 0 TO nXRanges
      IF lxVal
         IF nRange*nI <= nXMax
            cName := "xPVal_Name_"+Ltrim(Str(nI))
            @ nRPos, nLeft-nDeep-70 LABEL &cName OF &parent ;
			VALUE Transform(nRange*nI, cPicture) ;
			WIDTH 60 ;
			HEIGHT 14 ;
         FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
         ENDIF
         IF nRange*(-nI) >= nXMin*(-1)
            cName := "xNVal_Name_"+Ltrim(Str(nI))
            @ nRNeg, nLeft-nDeep-70 LABEL &cName OF &parent ;
			VALUE Transform(nRange*-nI, cPicture) ;
			WIDTH 60 ;
			HEIGHT 14 ;
         FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
         ENDIF
      ENDIF
      IF lxGrid
         IF nRange*nI <= nXMax
            IF l3D
               FOR nJ := 0 TO nDeep + 1
                  DrawLine( parent, nRPos + nJ, nLeft - nJ - 1, nRPos + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLine( parent, nRPos, nLeft, nRPos, nRight, BLACK )
         ENDIF
         IF nRange*-nI >= nXMin*-1
            IF l3D
               FOR nJ := 0 TO nDeep + 1
                  DrawLine( parent, nRNeg + nJ, nLeft - nJ - 1, nRNeg + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLine( parent, nRNeg, nLeft, nRNeg, nRight, BLACK )
         ENDIF
      ENDIF
      nRPos -= ( nMaxBar / nXRanges )
      nRNeg += ( nMaxBar / nXRanges )
   NEXT nI

   IF lYGrid
      nPos:=IF(l3D, nTop, nTop-5 )
      nI  := nLeft + nWide
      FOR nJ := 1 TO nMax(aData)
         Drawline( parent, nBottom-nDeep, nI, nPos, nI, {100,100,100} )
         Drawline( parent, nBottom, nI-nDeep, nBottom-nDeep, nI, {100,100,100} )
         nI += nWide
      NEXT
   ENDIF

   DO WHILE .T.    // Bar adjust
      nPos = nLeft + ( nWide / 2 )
      nPos += ( nWide + nSep ) * ( Len(aSeries) + 1 ) * Len(aData[1])
      IF nPos > nRight
         nWide--
      ELSE
         EXIT
      ENDIF
   ENDDO

   nMin := nMax / nMaxBar
   nPos := nLeft + ( ( nWide + nSep ) / 2 )            // first point graph
//   nRange := ( ( nWide + nSep ) * Len(aSeries) ) / 2

   IF lyVal .AND. Len(aYVals) > 0                // Show yLabels
      nWideB  := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nI := nLeft + nWideB
      FOR nJ := 1 TO nMax(aData)
         cName := "yVal_Name_"+Ltrim(Str(nJ))
         @ nBottom + 8, nI - nDeep - IF(l3D, 0, 8) LABEL &cName OF &parent ;
                        VALUE aYVals[nJ] AUTOSIZE ;
                        FONTCOLOR BLUE ;
                        FONT "Arial" SIZE 8 TRANSPARENT
         nI += nWideB
      NEXT
   ENDIF

   // Bars
   //
   IF nType == BARS .AND. nMin <> 0
      nPos := nLeft + ( ( nWide + nSep ) / 2 )
      FOR nI=1 TO Len(aData[1])
         FOR nJ=1 TO Len(aSeries)
            DrawBar( parent, nPos, nZero, aData[nJ,nI] / nMin + nDeep, nWide, l3D, nDeep, aColors[nJ] )
            nPos += nWide+nSep
         NEXT nJ
         nPos += nWide+nSep
      NEXT nI
   ENDIF

   // Lines
   //
   IF nType == LINES .AND. nMin <> 0
      nWideB  := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nPos := nLeft + nWideB
      FOR nI := 1 TO Len(aData[1])
         FOR nJ=1 TO Len(aSeries)
            IF !l3D
               DrawPoint( parent, nType, nPos, nZero, aData[nJ,nI] / nMin + nDeep, aColors[nJ] )
            ENDIF
            aPoint[nJ,nI,2] := nPos
            aPoint[nJ,nI,1] := nZero - ( aData[nJ,nI] / nMin + nDeep )
         NEXT nJ
         nPos += nWideB
      NEXT nI

      FOR nI := 1 TO Len(aData[1])-1
         FOR nJ := 1 TO Len(aSeries)
            IF l3D
               drawpolygon(parent,{{aPoint[nJ,nI,1],aPoint[nJ,nI,2]},{aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2]}, ;
                           {aPoint[nJ,nI+1,1]-nDeep,aPoint[nJ,nI+1,2]+nDeep},{aPoint[nJ,nI,1]-nDeep,aPoint[nJ,nI,2]+nDeep}, ;
                           {aPoint[nJ,nI,1],aPoint[nJ,nI,2]}},,,aColors[nJ])
            ELSE
               DrawLine(parent,aPoint[nJ,nI,1],aPoint[nJ,nI,2],aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2],aColors[nJ])
            ENDIF
         NEXT nI
      NEXT nI

   ENDIF

   // Points
   //
   IF nType == POINTS .AND. nMin <> 0
      nWideB := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nPos := nLeft + nWideB
      FOR nI := 1 TO Len(aData[1])
         FOR nJ=1 TO Len(aSeries)
            DrawPoint( parent, nType, nPos, nZero, aData[nJ,nI] / nMin + nDeep, aColors[nJ] )
            aPoint[nJ,nI,2] := nPos
            aPoint[nJ,nI,1] := nZero - aData[nJ,nI] / nMin
         NEXT nJ
         nPos += nWideB
      NEXT nI
   ENDIF

   IF lViewVal
      IF nType == BARS
         nPos := nLeft + nWide + ( (nWide+nSep) * ( Len(aSeries) / 2 ) )
      ELSE
         nWideB := ( nRight - nLeft ) / ( nMax(aData) + 1 )
         nPos := nLeft + nWideB
      ENDIF
      FOR nI := 1 TO Len(aData[1])
         FOR nJ := 1 TO Len(aSeries)
            cName := "Data_Name_"+Ltrim(Str(nI))+Ltrim(Str(nJ))
            @ nZero - ( aData[nJ,nI] / nMin + nDeep ), IF(nType == BARS, nPos - IF(l3D, 8, 10), nPos + 10) ;
			LABEL &cName OF &parent ;
			VALUE Transform(aData[nJ,nI], cPicture) AUTOSIZE ;
			FONT "Arial" SIZE 8 BOLD TRANSPARENT
            nPos+=IF( nType == BARS, nWide + nSep, 0)
         NEXT nJ
         IF nType == BARS
            nPos += nWide + nSep
         ELSE
            nPos += nWideB
         ENDIF
      NEXT nI
   ENDIF

   IF l3D
      DrawLine( parent, nZero, nLeft-nDeep, nZero, nRight-nDeep, BLACK )
   ELSE
      IF nXMax<>0 .AND. nXMin<>0
         DrawLine( parent, nZero-1, nLeft-2, nZero-1, nRight, RED )
      ENDIF
   ENDIF

RETURN


STAT PROC DrawBar( parent, nY, nX, nHigh, nWidth, l3D, nDeep, aColor )
   LOCAL nI, nColTop, nShadow, nH := nHigh

   nColTop := ClrShadow( RGB(aColor[1],aColor[2],aColor[3]), 15 )
   nShadow := ClrShadow( nColTop, 15 )
   nColTop := {GetRed(nColTop),GetGreen(nColTop),GetBlue(nColTop)}
   nShadow := {GetRed(nShadow),GetGreen(nShadow),GetBlue(nShadow)}

   FOR nI=1 TO nWidth
      DrawLine( parent, nX, nY+nI, nX+nDeep-nHigh, nY+nI, aColor )  // front
   NEXT nI

   IF l3D
      // Lateral
      drawpolygon( parent,{{nX-1,nY+nWidth+1},{nX+nDeep-nHigh,nY+nWidth+1},;
                   {nX-nHigh+1,nY+nWidth+nDeep},{nX-nDeep,nY+nWidth+nDeep},;
                   {nX-1,nY+nWidth+1}},nShadow,,nShadow )
      // Superior
      nHigh   := Max( nHigh, nDeep )
      drawpolygon( parent,{{nX-nHigh+nDeep,nY+1},{nX-nHigh+nDeep,nY+nWidth+1},;
                   {nX-nHigh+1,nY+nWidth+nDeep},{nX-nHigh+1,nY+nDeep},;
                   {nX-nHigh+nDeep,nY+1}},nColTop,,nColTop )
      // Border
      DrawBox( parent, nY, nX, nH, nWidth, l3D, nDeep )
   ENDIF

RETURN

STATIC PROC DrawBox( parent, nY, nX, nHigh, nWidth, l3D, nDeep )

   // Set Border
   DrawLine( parent, nX, nY        , nX-nHigh+nDeep    , nY       , BLACK )  // Left
   DrawLine( parent, nX, nY+nWidth , nX-nHigh+nDeep    , nY+nWidth, BLACK )  // Right
   DrawLine( parent, nX-nHigh+nDeep, nY, nX-nHigh+nDeep, nY+nWidth, BLACK )  // Top
   DrawLine( parent, nX, nY, nX, nY+nWidth, BLACK )                          // Bottom
   IF l3D
      // Set shadow
      DrawLine( parent, nX-nHigh+nDeep, nY+nWidth, nX-nHigh, nY+nDeep+nWidth, BLACK )
      DrawLine( parent, nX, nY+nWidth, nX-nDeep, nY+nWidth+nDeep, BLACK )
      IF nHigh > 0
         DrawLine( parent, nX-nDeep, nY+nWidth+nDeep, nX-nHigh, nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX-nHigh, nY+nDeep, nX-nHigh , nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX-nHigh+nDeep, nY, nX-nHigh, nY+nDeep, BLACK )
      ELSE
         DrawLine( parent, nX-nDeep, nY+nWidth+nDeep, nX-nHigh+1, nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX, nY, nX-nDeep, nY+nDeep, BLACK )
      ENDIF
   ENDIF

RETURN


STATIC PROC DrawPoint( parent, nType, nY, nX, nHigh, aColor )

   IF nType == POINTS

         Circle( parent, nX - nHigh - 3, nY - 3, 8, aColor )

   ELSEIF nType == LINES

      Circle( parent, nX - nHigh - 2, nY - 2, 6, aColor )

   ENDIF

RETURN


STATIC PROC Circle( window, nCol, nRow, nWidth, aColor )
	drawellipse(window, nCol, nRow, nCol + nWidth - 1, nRow + nWidth - 1, , , aColor)
RETURN


STATIC FUNCTION nMax(aData)
   LOCAL nI, nMax := 0

   FOR nI :=1 TO Len( aData )
      nMax := Max( Len(aData[nI]), nMax )
   NEXT nI

RETURN( nMax )


STATIC FUNCTION DetMaxVal(nNum)
   LOCAL nE, nMax, nMan, nVal, nOffset

   nE:=9
   nVal:=0
   nNum:=Abs(nNum)

   DO WHILE .T.

      nMax := 10**nE

      IF Int(nNum/nMax)>0

         nMan:=(nNum/nMax)-Int(nNum/nMax)
         nOffset:=1
         nOffset:=IF(nMan<=.75,.75,nOffset)
         nOffset:=IF(nMan<=.50,.50,nOffset)
         nOffset:=IF(nMan<=.25,.25,nOffset)
         nOffset:=IF(nMan<=.00,.00,nOffset)
         nVal := (Int(nNum/nMax)+nOffset)*nMax
         EXIT

      ENDIF

      nE--

   ENDDO

RETURN (nVal)


STATIC FUNCTION ClrShadow( nColor, nFactor )
   LOCAL aHSL, aRGB

   aHSL := RGB2HSL( GetRed(nColor), GetGreen(nColor), GetBlue(nColor) )
   aHSL[3] -= nFactor
   aRGB := HSL2RGB( aHSL[1], aHSL[2], aHSL[3] )

RETURN RGB( aRGB[1], aRGB[2], aRGB[3] )


STATIC FUNCTION RGB2HSL( nR, nG, nB )
   LOCAL nMax, nMin
   LOCAL nH, nS, nL

   IF nR < 0
      nR := Abs( nR )
      nG := GetGreen( nR )
      nB := GetBlue( nR )
      nR := GetRed( nR )
   ENDIF

   nR := nR / 255
   nG := nG / 255
   nB := nB / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nL := ( nMax + nMin ) / 2

   IF nMax = nMin
      nH := 0
      nS := 0
   ELSE
      IF nL < 0.5
         nS := ( nMax - nMin ) / ( nMax + nMin )
      ELSE
         nS := ( nMax - nMin ) / ( 2.0 - nMax - nMin )
      ENDIF
      DO CASE
         CASE nR = nMax
            nH := ( nG - nB ) / ( nMax - nMin )
         CASE nG = nMax
            nH := 2.0 + ( nB - nR ) / ( nMax - nMin )
         CASE nB = nMax
            nH := 4.0 + ( nR - nG ) / ( nMax - nMin )
      ENDCASE
   ENDIF

   nH := Int( (nH * 239) / 6 )
   IF nH < 0 ; nH += 240 ; ENDIF
   nS := Int( nS * 239 )
   nL := Int( nL * 239 )

RETURN { nH, nS, nL }


STATIC FUNCTION HSL2RGB( nH, nS, nL )
   LOCAL nFor
   LOCAL nR, nG, nB
   LOCAL nTmp1, nTmp2, aTmp3 := { 0, 0, 0 }

   nH /= 239
   nS /= 239
   nL /= 239
   IF nS == 0
      nR := nL
      nG := nL
      nB := nL
   ELSE
      IF nL < 0.5
         nTmp2 := nL * ( 1 + nS )
      ELSE
         nTmp2 := nL + nS - ( nL * nS )
      ENDIF
      nTmp1 := 2 * nL - nTmp2
      aTmp3[1] := nH + 1 / 3
      aTmp3[2] := nH
      aTmp3[3] := nH - 1 / 3
      FOR nFor := 1 TO 3
         IF aTmp3[nFor] < 0
            aTmp3[nFor] += 1
         ENDIF
         IF aTmp3[nFor] > 1
            aTmp3[nFor] -= 1
         ENDIF
         IF 6 * aTmp3[nFor] < 1
            aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * 6 * aTmp3[nFor]
         ELSE
            IF 2 * aTmp3[nFor] < 1
               aTmp3[nFor] := nTmp2
            ELSE
               IF 3 * aTmp3[nFor] < 2
                  aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * ( ( 2 / 3 ) - aTmp3[nFor] ) * 6
               ELSE
                  aTmp3[nFor] := nTmp1
               ENDIF
            ENDIF
         ENDIF
      NEXT nFor
      nR := aTmp3[1]
      nG := aTmp3[2]
      nB := aTmp3[3]
   ENDIF

RETURN { Int( nR * 255 ), Int( nG * 255 ), Int( nB * 255 ) }


function DrawWindowBoxIn(window,row,col,rowr,colr)
Local oWnd := GetFormObject( Window )

/*
   WndBoxInDraw( oWnd:hWnd, row, col, rowr, colr )
   aadd ( oWnd:GraphTasks, { || WndBoxInDraw( oWnd:hWnd, row, col, rowr, colr ) } )
*/
   oWnd:GraphCommand := { | hWnd, aData | _OOHG_GraphCommand( hWnd, aData ) }
   aadd( oWnd:GraphData, _OOHG_NewGraphCommand( oWnd:hWnd, 7, row, col, rowr, colr ) )

return nil


function drawpiegraph(windowname,fromrow,fromcol,torow,tocol,series,aname,colors,ctitle,depth,l3d,lxval,lsleg,lnoborder)
local topleftrow // := fromrow
local topleftcol // := fromcol
local toprightrow // := fromrow
local toprightcol // := tocol
local bottomrightrow // := torow
local bottomrightcol // := tocol
local bottomleftrow // := torow
local bottomleftcol // := fromcol
// local middletoprow := fromrow
local middletopcol // := fromcol + int(tocol - fromcol) / 2
local middleleftrow // := fromrow + int(torow - fromrow) / 2
local middleleftcol // := fromcol
// local middlebottomrow := torow
local middlebottomcol // := fromcol + int(tocol - fromcol) / 2
local middlerightrow // := fromrow + int(torow - fromrow) / 2
local middlerightcol // := tocol
local fromradialrow // := 0
local fromradialcol // := 0
local toradialrow // := 0
local toradialcol // := 0
local degrees := {}
local cumulative := {}
local j,i,sum := 0
local cname // := ""
local shadowcolor // := {}

   If ! lNoBorder

      DrawLine( windowname, torow      , fromcol    , torow      , tocol      , WHITE )
      DrawLine( windowname, torow  - 1 , fromcol + 1, torow   - 1, tocol - 1  , GRAY  )
      DrawLine( windowname, torow  - 1 , fromcol    , fromrow    , fromcol    , GRAY  )
      DrawLine( windowname, torow  - 2 , fromcol + 1, fromrow + 1, fromcol + 1, GRAY  )
      DrawLine( windowname, fromrow    , fromcol    , fromrow    , tocol - 1  , GRAY  )
      DrawLine( windowname, fromrow + 1, fromcol + 1, fromrow + 1, tocol - 2  , GRAY  )
      DrawLine( windowname, fromrow    , tocol      , torow      , tocol      , WHITE )
      DrawLine( windowname, fromrow    , tocol - 1  , torow - 1  , tocol - 1  , GRAY  )

   EndIf

if len(alltrim(ctitle)) > 0
   if _iscontroldefined("title_of_pie",windowname)
      DoMethod( windowname, "title_of_pie", "Release" )
   endif
   define label title_of_pie
      parent &windowname
      row fromrow + 10
      col iif(len(alltrim(ctitle)) * 12 > (tocol - fromcol),fromcol,int(((tocol - fromcol) - (len(alltrim(ctitle)) * 12))/2) + fromcol)
      autosize .t.
      fontcolor {0,0,255}
      fontbold .t.
      fontname "Arial"
      fontunderline .t.
      fontsize 12
      value alltrim(ctitle)
      Transparent .t.
   end label
   fromrow := fromrow + 40
endif

if lsleg
   if len(aname) * 20 > (torow - fromrow)
      msginfo("No space for showing legends")
   else
      torow := torow - (len(aname) * 20)
   endif
endif

drawrect(windowname,fromrow+10,fromcol+10,torow-10,tocol-10,{0,0,0},1,{255,255,255})

if l3d
   torow := torow - depth
endif

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
middletopcol := fromcol + int(tocol - fromcol) / 2
middleleftrow := fromrow + int(torow - fromrow) / 2
middleleftcol := fromcol
// middlebottomrow := torow
middlebottomcol := fromcol + int(tocol - fromcol) / 2
middlerightrow := fromrow + int(torow - fromrow) / 2
middlerightcol := tocol






torow := torow + 1
tocol := tocol + 1

for i := 1 to len(series)
   sum := sum + series[i]
next i
for i := 1 to len(series)
   aadd(degrees,round(series[i]/sum * 360,0))
next i
sum := 0
for i := 1 to len(degrees)
   sum := sum + degrees[i]
next i
if sum <> 360
   degrees[len(degrees)] := degrees[len(degrees)] + (360 - sum)
endif

sum := 0
for i := 1 to len(degrees)
   sum := sum + degrees[i]
   aadd(cumulative,sum)
next i


fromradialrow := middlerightrow
fromradialcol := middlerightcol
for i := 1 to len(cumulative)
   shadowcolor := {iif(colors[i,1] > 50,colors[i,1] - 50,0),iif(colors[i,2] > 50,colors[i,2] - 50,0),iif(colors[i,3] > 50,colors[i,3] - 50,0)}
   do case
      case cumulative[i] <= 45
         toradialcol := middlerightcol
         toradialrow := middlerightrow - round(cumulative[i] / 45 * (middlerightrow - toprightrow),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 90 .and. cumulative[i] > 45
         toradialrow := toprightrow
         toradialcol := toprightcol - round((cumulative[i] - 45) / 45 * (toprightcol - middletopcol),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 135 .and. cumulative[i] > 90
         toradialrow := topleftrow
         toradialcol := middletopcol - round((cumulative[i] - 90) / 45 * (middletopcol - topleftcol),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 180 .and. cumulative[i] > 135
         toradialcol := topleftcol
         toradialrow := topleftrow + round((cumulative[i] - 135) / 45 * (middleleftrow - topleftrow),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 225 .and. cumulative[i] > 180
         toradialcol := topleftcol
         toradialrow := middleleftrow + round((cumulative[i] - 180) / 45 * (bottomleftrow - middleleftrow),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 270 .and. cumulative[i] > 225
         toradialrow := bottomleftrow
         toradialcol := bottomleftcol + round((cumulative[i] - 225) / 45 * (middlebottomcol - bottomleftcol),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 315 .and. cumulative[i] > 270
         toradialrow := bottomleftrow
         toradialcol := middlebottomcol + round((cumulative[i] - 270) / 45 * (bottomrightcol - middlebottomcol),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 360 .and. cumulative[i] > 315
         toradialcol := bottomrightcol
         toradialrow := bottomrightrow - round((cumulative[i] - 315) / 45 * (bottomrightrow - middlerightrow),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      endcase
   if l3d
      drawline(windowname,middleleftrow,middleleftcol,middleleftrow+depth,middleleftcol)
      drawline(windowname,middlerightrow,middlerightcol,middlerightrow+depth,middlerightcol)
      drawarc(windowname,fromrow + depth,fromcol,torow + depth,tocol,middleleftrow+depth,middleleftcol,middlerightrow+depth,middlerightcol)
   endif
next i
if lsleg
   fromrow := torow + 20 + iif(l3d,depth,0)
   for i := 1 to len(aname)
      if _iscontroldefined("pielegend_"+alltrim(str(i,3,0)),windowname)
         DoMethod( windowname, "pielegend_"+alltrim(str(i,3,0)), "Release" )
      endif
      cname := "pielegend_"+alltrim(str(i,3,0))
      drawrect(windowname,fromrow,fromcol,fromrow + 15,fromcol + 15,{0,0,0},1,colors[i])
      define label &cname
         parent &windowname
         row fromrow
         col fromcol + 20
         fontname "Arial"
         fontsize 8
         autosize .t.
         value aname[i]+iif(lxval," - "+alltrim(str(series[i],10,2))+" ("+alltrim(str(degrees[i] / 360 * 100,6,2))+" %)","")
         fontcolor colors[i]
         Transparent .t.
      end label
      fromrow := fromrow + 20
   next i
endif
return nil
