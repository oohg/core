/*
 * $Id: demo.prg,v 1.4 2017-08-25 19:28:45 fyurisich Exp $
 */
/*
 * This demo shows how to use DRAW GRAPH.
 * Copyright (c)2007-2017 MigSoft <migsoft/at/oohg.org>
 */

#include "oohg.ch"

#define AZUL		{   0 , 128 , 192  }
#define CELESTE		{   0 , 128 , 255  }
#define VERDE		{   0 , 128 , 128  }
#define CAFE		{ 128 , 64  ,   0  }

Static aYvalAll   := { "Ene", "Feb", "Mar", "Abr", "May", "Jun", ;
                       "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"  }
Static aYval1er   := { "Ene", "Feb", "Mar", "Abr", "May", "Jun" }
Static aYval2do   := { "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" }

Static aSerieNames

Procedure Main
local aClr := { RED,YELLOW,AZUL,ORANGE,VERDE,FUCHSIA,GREEN,CAFE, ;
                BLUE,BROWN,PINK,PURPLE, BLACK, WHITE, GRAY       }
local n := 1, cNombre, m
local nReg, aColor, aColor1, aSer, aSer1, aSer2

   USE SALDOMES

   nReg        := RecCount()
   aColor      := array(nReg)
   aColor1     := array(nReg)
   aSerieNames := array(nReg)
   aSer        := array(nReg,12)
   aSer1       := array(nReg,6)
   aSer2       := array(nReg,6)

   do while ! saldomes->(eof())
      cNombre        := lower(saldomes->Banco)
      aSerieNames[n] := cNombre
      aSer[n,1] := saldomes->enero      ; aSer[n,2] := saldomes->febrero
      aSer[n,3] := saldomes->marzo      ; aSer[n,4] := saldomes->abril
      aSer[n,5] := saldomes->mayo       ; aSer[n,6] := saldomes->junio
      aSer[n,7] := saldomes->julio      ; aSer[n,8] := saldomes->agosto
      aSer[n,9] := saldomes->septiembre ; aSer[n,10]:= saldomes->octubre
      aSer[n,11]:= saldomes->noviembre  ; aSer[n,12]:= saldomes->diciembre
      aColor[n] := aClr[n]
      skip
      n++
   enddo

   For n = 1 to nReg              
       For m = 1 to 6
           aSer1[n,m] := aSer[n,m]
           aSer2[n,m] := aSer[n,m+6]
       Next
       aColor1[n]      := aClr[n]
   Next

   Define Window GraphTest ;
	  At 0,0 ;
	  Width 720 ;
	  Height 480 ;
	  Title "Graph Demo By MigSoft" ;
	  Main ;
	  Icon "Graph.ico" ;
	  nomaximize nosize ;
	  On Init DrawBarGraph(aSer,aYvalAll,aColor)

	  Define Button Button_1
	  Row	405
	  Col	40
	  Caption	'1er Semestre'
	  Action DrawBarGraph(aSer1,aYval1er,aColor1)
	  End Button

	  Define Button Button_2
	  Row	405
	  Col	180
	  Caption	'2do Semestre'
	  Action DrawBarGraph(aSer2,aYval2do,aColor1)
	  End Button

	  Define Button Button_3
	  Row	405
	  Col	320
	  Caption	'Lineas'
	  Action DrawLinesGraph(aSer,aYvalAll,aColor)
	  End Button

	  Define Button Button_4
	  Row	405
	  Col	460
	  Caption	'Puntos'
	  Action DrawPointsGraph(aSer,aYvalAll,aColor)
	  End Button

	  On Key ESCAPE Action ThisWindow.Release

   End Window

   GraphTest.Center
   Activate Window GraphTest

Return

Procedure DrawBarGraph(paSer,paYval,paCol)

   ERASE WINDOW GraphTest

   DRAW GRAPH IN WINDOW GraphTest           ;
          AT 20,20                          ;
          TO 400,700                        ;
	  TITLE "Saldo por Banco"           ;
	  TYPE BARS                         ;
	  SERIES paSer                      ;
	  YVALUES paYval                    ;
	  DEPTH 15                          ;
	  BARWIDTH 15                       ;
	  HVALUES 5                         ;
	  SERIENAMES aSerieNames            ;
	  COLORS paCol                      ;
	  3DVIEW                            ;
	  SHOWGRID                          ;
	  SHOWXVALUES                       ;
	  SHOWYVALUES                       ;
	  SHOWLEGENDS


Return

Procedure DrawLinesGraph(paSer,paYval,paCol)

   ERASE WINDOW GraphTest

   DRAW GRAPH IN WINDOW GraphTest           ;
	  AT 20,20                          ;
	  TO 400,700                        ;
	  TITLE "Saldo por Banco"           ;
	  TYPE LINES                        ;
	  SERIES paSer                      ;
	  YVALUES paYval                    ;
	  DEPTH 15                          ;
	  BARWIDTH 15                       ;
	  HVALUES 5                         ;
	  SERIENAMES aSerieNames            ;
	  COLORS paCol                      ;
	  3DVIEW                            ;
	  SHOWGRID                          ;
	  SHOWXVALUES                       ;
	  SHOWYVALUES                       ;
	  SHOWLEGENDS


Return

Procedure DrawPointsGraph(paSer,paYval,paCol)

   ERASE WINDOW GraphTest

   DRAW GRAPH IN WINDOW GraphTest           ;
   	  AT 20,20                          ;
	  TO 400,700                        ;
          TITLE "Saldo por Banco"           ;
	  TYPE POINTS                       ;
	  SERIES paSer                      ;
	  YVALUES paYval                    ;
	  DEPTH 15                          ;
	  BARWIDTH 15                       ;
	  HVALUES 5                         ;
	  SERIENAMES aSerieNames            ;
	  COLORS paCol                      ;
	  3DVIEW                            ;
	  SHOWGRID                          ;
	  SHOWXVALUES                       ;
	  SHOWYVALUES                       ;
	  SHOWLEGENDS


Return
