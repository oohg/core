/*
 * $Id: repoedit.prg,v 1.3 2014-06-19 18:53:30 fyurisich Exp $
 */

#include "oohg.ch"

#define CRLF CHR(13)+CHR(10)

//------------------------------------------------------------------------------
Function Repo_Edit( myIde, cFileRep )
//------------------------------------------------------------------------------
Local nContLin, i
Local cTitle := ''
Local aHeaders := '{},{}'
Local aFields := '{}'
Local aWidths := '{}'
Local aTotals := ''
Local nFormats := ''
Local nLPP := 50
Local nCPL := 80
Local nLMargin := 0
Local cPaperSize := 'DMPAPER_LETTER'
Local cAlias := ''
Local lDos := .F.
Local lPreview := .F.
Local lSelect := .F.
Local lMul := .F.
Local cGraphic := " '     ' at 0,0 to 0,0"
Local cGrpBy := ''
Local cHdrGrp := ''
Local lLandscape := .F.
Local aResults

   myIde:aLineR := {}
   myIde:lVirtual := .T.
   cReport := MemoRead( cFileRep )
   If File( cFileRep )
      nContLin := MLCount( cReport )
      For i := 1 To nContLin
         aAdd( myIde:aLineR, MemoLine( cReport, 500, i ) )
      Next i
      cTitle     := LeaDatoR( myIde, 'REPORT', 'TITLE', '' )
      aHeaders   := LeaDatoR( myIde, 'REPORT', 'HEADERS', '{},{}' )
      aFields    := LeaDatoR( myIde, 'REPORT', 'FIELDS', '{}' )
      aWidths    := LeaDatoR( myIde, 'REPORT', 'WIDTHS', '{}' )
      aTotals    := LeaDatoR( myIde, 'REPORT', 'TOTALS', '' )
      nFormats   := LeaDatoR( myIde, 'REPORT', 'NFORMATS', '' )
      nLPP       := Val( LeaDatoR( myIde, 'REPORT', 'LPP', '55' ) )
      nCPL       := Val( LeaDatoR( myIde, 'REPORT', 'CPL', '80' ) )
      nLMargin   := Val( LeaDatoR( myIde, 'REPORT', 'LMARGIN', '' ) )
      cPaperSize := LeaDatoR( myIde, 'REPORT', 'PAPERSIZE', '' )
      cAlias     := LeaDatoR( myIde, 'REPORT', 'WORKAREA', '' )
      lDos       := LeaDatoLogicR( myIde, 'REPORT', 'DOSMODE', .F.)
      lPreview   := LeaDatoLogicR( myIde, 'REPORT', 'PREVIEW', .F.)
      lSelect    := LeaDatoLogicR( myIde, 'REPORT', 'SELECT', .F.)
      lMul       := LeaDatoLogicR( myIde, 'REPORT', 'MULTIPLE', .F.)
      cGraphic   := LeaDatoR( myIde, 'REPORT', 'IMAGE', '')
      cGrpBy     := LeaDatoR( myIde, 'REPORT', 'GROUPED BY', '' )
      cHdrGrp    := CleanR( LeaDatoR( myIde, 'REPORT', 'HEADRGRP', '' ) )
      lLandscape := LeaDatoLogicR( myIde, 'REPORT', 'LANDSCAPE', .F. )
   EndIf

   aLabels     := { 'Title', 'Headers', 'Fields', 'Widths ', 'Totals', 'Nformats', 'Workarea', 'Lpp', 'Cpl', 'Lmargin', 'Dosmode', 'Preview', 'Select', 'Image / at - to', 'Multiple', 'Grouped by', 'Group header', 'Landscape', 'Papersize' }
   aInitValues := { cTitle,  aHeaders,  afields,  awidths,   atotals,  nformats,   calias,     nlpp,  ncpl,  nLMargin, ldos,      lpreview,  lselect,  cgraphic,          lmul,       cgrpby,       cHdrGrp,        lLandscape,   cpapersize }
   aFormats    := { 320,     320,       320,      160,       160,      320,        20,         '999', '999', '999',     .F.,       .T.,       .F.,      50,                .F.,        50,           28,             .F.,         30 }
   aResults    := myInputWindow( "Report parameters of " + cFileRep, aLabels, aInitValues, aFormats )
   If aResults[1] == Nil
      Return Nil
   EndIf

   Output := 'DO REPORT ;' + CRLF
   Output += "TITLE " + aResults[1] + ' ;' + CRLF
   Output += "HEADERS " + aResults[2] + ' ;' + CRLF
   Output += "FIELDS " + aResults[3] + ' ;' + CRLF
   Output += "WIDTHS " + aResults[4] + ' ;' + CRLF
   If Len( aResults[5] ) > 0
      Output += "TOTALS " + aResults[5] + ' ;' + CRLF
   EndIf
   If Len( aResults[6] ) > 0
      Output += "NFORMATS " + aResults[6] + ' ;' + CRLF
   EndIf
   Output += "WORKAREA " + aResults[7] + ' ;' + CRLF
   Output += "LPP " + Str( aResults[8], 3 ) + ' ;' + CRLF
   Output += "CPL " + Str( aResults[9], 3 ) + ' ;' + CRLF
   If aResults[10] > 0
      Output += "LMARGIN " + Str( aResults[10], 3 ) + ' ;' + CRLF
   EndIf
   If Len( aResults[19] ) > 0
      Output += "PAPERSIZE " + Upper( aResults[19] ) + ' ;' + CRLF
   EndIf
   If aResults[11]
      Output += "DOSMODE " + ' ;' + CRLF
   EndIf
   If aResults[12]
      Output += "PREVIEW " + ' ;' + CRLF
   EndIf
   If aResults[13]
      Output += "SELECT " + ' ;' + CRLF
   EndIf
   If Len( aResults[14] ) > 0
      Output += "IMAGE " + aResults[14] + ' ;' + CRLF
   EndIf
   If aResults[15]
      Output += "MULTIPLE " + ' ;' + CRLF
   EndIf
   If Len( aResults[16] ) > 0
      Output += "GROUPED BY " + aResults[16] + ' ;' + CRLF
   EndIf
   If Len( aResults[17] ) > 0
      Output += "HEADRGRP " + "'" + aResults[17] + "'" + ' ;' + CRLF
   EndIf
   If aResults[18]
      Output += "LANDSCAPE " + ' ;' + CRLF
   EndIf
   Output += CRLF + CRLF
   If MemoWrit( cFileRep, Output )
      MsgInfo( 'Report saved', 'ooHG IDE+' )
   Else
      MsgInfo( 'Error saving report', 'ooHG IDE+' )
   EndIf
Return Nil

//------------------------------------------------------------------------------
Function LeaDatoR( myIde, cName, cPropmet, cDefault )
//------------------------------------------------------------------------------
Local i, sw, cFValue
   sw := 0
   For i := 1 To Len( myIde:aLineR )
      If ! At( Upper( cName ) + ' ', Upper( myIde:aLineR[i] ) ) == 0
         sw := 1
      Else
         If sw == 1
            nPos := At( Upper( cPropmet ) + ' ', Upper( myIde:aLineR[i] ) )
            If Len( Trim( myIde:aLineR[i] ) ) == 0
               Return cDefault
            EndIf
            If nPos > 0
               cFValue := SubStr( myIde:aLineR[i], nPos + Len( cPropmet ), Len( myIde:aLineR[i] ) )
               cFValue := Trim( cFValue )
               If Right( cFValue, 1 ) == ';'
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               Else
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) )
               EndIf
               Return AllTrim( cFValue )
            EndIf
         EndIf
      EndIf
   Next i
Return cDefault

/*
*-------------------------------------------
function leaimage(cName,cPropmet,cDefault)
*-------------------------------------------
local i,sw
sw1:=0
lin:=0
For i:=1 to len(myide:aliner)
        if at(upper('IMAGE'),myide:aliner[i])>0
               npos1:=at(upper('IMAGE'),upper(myide:aliner[i]))+6
               npos2:=at(upper('AT'),upper(myide:aliner[i]))-1
            lin:=i
            i:=len(myide:aliner)+1
            sw1:=1
        endif
next i
if sw1=1
   return substr(myide:aliner[lin],npos1,npos2-npos1+1)
endif
return cDefault
*----------------------------------------------
function leadatoh(cName,cPropmet,cDefault,npar)
*----------------------------------------------
local i,sw
sw1:=0
lin:=0
For i:=1 to len(myide:aliner)
        if at(upper('HEADERS'),myide:aliner[i])>0
            if npar=1
               npos1:=at(upper('{'),upper(myide:aliner[i]))
               npos2:=at(upper('}'),upper(myide:aliner[i]))
            else
               npos1:=rat(upper('{'),upper(myide:aliner[i]))
               npos2:=rat(upper('}'),upper(myide:aliner[i]))
            endif
            lin:=i
            i:=len(myide:aliner)+1
            sw1:=1
        endif
next i
if sw1=1
   return substr(myide:aliner[lin],npos1,npos2-npos1+1)
endif
return cDefault
*/

//------------------------------------------------------------------------------
Function LeaDatoLogicR( myIde, cName, cPropmet, cDefault )
//------------------------------------------------------------------------------
Local i, sw := 0
   For i := 1 To Len( myIde:aLineR )
      If At( Upper( cName ) + ' ', Upper( myIde:aLineR[i] ) ) # 0
         sw := 1
      Else
         If sw == 1
            If At( Upper( cPropmet ) + ' ', Upper( myIde:aLineR[i] ) ) > 0
               Return .T.
            EndIf
            If Len( Trim( myIde:aLineR[i] ) ) == 0
               Return cDefault
            EndIf
         EndIf
      EndIf
   Next i
Return cDefault

//------------------------------------------------------------------------------
Function CleanR( cFValue )
//------------------------------------------------------------------------------
   cFValue  :=  strtran( cFValue, '"', '' )
   cFValue  :=  strtran( cFValue, "'", "" )
Return cFValue

/*
*----------------------------
function learowi(cname,npar)
*----------------------------
local i,npos1,npos2,nrow
sw:=0
nrow:='0'
For i:=1 to len(myide:aliner)
    if at(upper('IMAGE')+' ',upper(myide:aliner[i]))#0
       if npar=1
          npos1:=at("AT",upper(myide:aliner[i]))
          npos2:=at(",",myide:aliner[i])
       else
          npos1:=at("TO",upper(myide:aliner[i]))
          npos2:=rat(",",myide:aliner[i])
       endif
       nrow:=substr(myide:aliner[i],npos1+3,len(myide:aliner[i])-npos2)
       i:=len(myide:aliner)
    endif
Next i
return nrow

*---------------------------
function leacoli(cname,npar)
*---------------------------
local i,npos,ncol
ncol:='0'
For i:=1 to len(myide:aliner)
if at(upper('IMAGE')+' ',upper(myide:aliner[i]))#0
   if npar=1
      npos:=at(",",myide:aliner[i])
      ncol:=substr(myide:aliner[i],npos+1,3)
   else
      npos:=rat(",",myide:aliner[i])
      ncol:=substr(myide:aliner[i],npos+1,3)
   endif
   i:=len(myide:aliner)
endif
Next i
return ncol
*/
