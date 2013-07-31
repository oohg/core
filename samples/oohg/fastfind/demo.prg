/*
 * $Id: demo.prg,v 1.1 2013-07-31 14:06:59 migsoft Exp $
 */
/*
 * This demo shows how to use GRID.
 * Copyright (c)2007-2013 MigSoft <migsoft/at/oohg.org>
 *
 */

#include "oohg.ch"

 Procedure Main()

   Set Multiple Off Warning

   Use Cuentas
   Index On field->nombre To cuentas

   Load window Win_1
   Center window Win_1
   Win_1.Text_1.Setfocus
   Activate window Win_1

Return
*--------------------------------------------------------------*
Function Captura()
*--------------------------------------------------------------*
   Local cCapt       := Upper(AllTrim(win_1.Text_1.value))
   Local nTaman      := Len(cCapt)
   Local nRegProc    := 0
   Local nMaxRegGrid := 70
   Memvar cCampo
   Private cCampo    := "NOMBRE"

   DBSELECTAREA("Cuentas")
   DBSeek(cCapt)

   win_1.Grid_1.DisableUpdate
   DELETE ITEM ALL FROM Grid_1 OF Win_1

   Do While !EOF()
      If Substr(FIELD->&cCampo,1,nTaman) == cCapt
         nRegProc += 1
         If nRegProc > nMaxRegGrid
            EXIT
         Endif
         ADD ITEM { TRANSF(Cuentas->Imputacion,"9999999") , ;
                           Cuentas->Nombre } TO Grid_1 of Win_1
      ElseIf Substr(FIELD->&cCampo,1,nTaman) > cCapt
         EXIT
      Endif
      DBSkip()
   Enddo
   win_1.Grid_1.EnableUpdate
Return NIL
*--------------------------------------------------------------*
Procedure VerItem()
*--------------------------------------------------------------*
   MsgInfo( 'Col 1: ' + GetColValue( "Grid_1", "Win_1", 1 )+'  ';
          + 'Col 2: ' + GetColValue( "Grid_1", "Win_1", 2 ) )
Return
*--------------------------------------------------------------*
Function GetColValue( xObj, xForm, nCol )
*--------------------------------------------------------------*
  Local nPos:= GetProperty(xForm, xObj, 'Value')
  Local aRet:= GetProperty(xForm, xObj, 'Item', nPos)
Return aRet[nCol]
*--------------------------------------------------------------*
Function SetColValue( xObj, xForm, nCol, xValue )
*--------------------------------------------------------------*
  Local nPos:= GetProperty(xForm, xObj, 'Value')
  Local aRet:= GetProperty(xForm, xObj, 'Item', nPos)
      aRet[nCol] := xValue
      SetProperty(xForm, xObj, 'Item', nPos, aRet)
Return NIL
