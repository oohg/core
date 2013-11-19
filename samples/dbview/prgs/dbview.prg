/*
 * $Id: dbview.prg,v 1.1 2013-11-19 19:15:41 migsoft Exp $
 */

/*
 *
 * MINIGUI - Harbour Win32 GUI library
 * Copyright 2002-2012 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Program to view DBF files using standard Browse control
 * Miguel Angel Juárez A. - 2009-2012 MigSoft <mig2soft/at/yahoo.com>
 * Includes the code of Grigory Filatov <gfilatov@freemail.ru>
 * and Rathinagiri <srathinagiri@gmail.com>
 *
 */

#include "oohg.ch"
#include "dbstruct.ch"
#include "fileio.ch"
#include "dbuvar.ch"
#include "hbcompat.ch"

*------------------------------------------------------------------------------*
Function Main( cDBF )
*------------------------------------------------------------------------------*

   REQUEST DBFNTX
   REQUEST DBFCDX, DBFFPT
   RDDSETDEFAULT( "DBFCDX" )
   SET AUTOPEN OFF

   Publicar()

   Load window oWndBase

   ON KEY F3 OF oWndBase ACTION AutoMsgInfo( aFiles, "aFiles" )
   ON KEY F4 OF oWndBase ACTION AutoMsgInfo( nRecCopy, "nRecCopy" )
   ON KEY F5 OF oWndBase ACTION AutoMsgInfo( ( Alias() )->( Select() ), "Select()" )
   ON KEY F6 OF oWndBase ACTION AutoMsgInfo( ( Alias() )->( Dbf() ), "Dbf()" )
   ON KEY F7 OF oWndBase ACTION AutoMsgInfo( ( Alias() )->( Used() ), "Used()" )

   If PCOUNT() > 0
      OpenBase( cDBF )
   Else
      OpenBase( "" )
   Endif

   oWndBase.Center
   oWndBase.Activate

Return Nil

*------------------------------------------------------------------------------*
Procedure Publicar()
*------------------------------------------------------------------------------*

    Public nAltoPantalla  := GetDesktopHeight() + GetTitleHeight() + GetBorderHeight()
    Public nAnchoPantalla := GetDesktopWidth()
    Public nRow           := nAltoPantalla  * 0.10
    Public nCol           := nAnchoPantalla * 0.10
    Public nWidth         := nAnchoPantalla * 0.95
    Public nHeight        := nAltoPantalla  * 0.85
    Public _OOHG_PRINTLIBRARY
    Public cBaseFolder, aTypes, aNewFile := {}, aFtype := {}, aCtrl := {}
    Public nCamp, aEst    := {}, aNomb := {}, aJust := {}, aLong := {}, i, cBase
    Public cFont          := 'MS Sans Serif'
    Public nSize          := 8 , Nuevo := .F.
    Public nRecCopy       := {}
    Public aArea          := {}
    Public aFiles         := {}
    Public nArea          := 0
    Public nBrow          := 0
    Public nBase          := 0
    Public nRecSel        := 0
    Public nPage          := 1
    Public aFntClr        := {0,0,0}
    Public aBackClr       := {255,255,255}
    Public aSearch        := {}, aReplace := {}
    Public nSearch        := 1, nReplace := 1, nColumns := 1
    Public lMatchCase     := .F., lMatchWhole := .F.
    Public nDirect        := 3, cDateFormat := "DD.MM.YYYY"
    Public _DBULastPath   := ''
    Public VERSION        := "v."+substr(__DATE__,3,2)+"."+right(__DATE__,4)
    HB_LANGSELECT( "EN" )
    DECLARE WINDOW Form_Query
    DECLARE WINDOW Form_Find
    DECLARE WINDOW _DBUcreadbf
    DECLARE WINDOW Form_Prop
    DECLARE WINDOW oWndBase

Return

*------------------------------------------------------------------------------*
Procedure OpenBase( cDBF )
*------------------------------------------------------------------------------*
   local nn, aTemp := {}

   cBaseFolder := GetStartupFolder()
   LoadArchIni(cBaseFolder+'\')

   If Empty(cDBF) .OR. ValType ( cDBF ) == 'U'
      If !IsControlDefined(Tab_1,oWndBase)
         oWndBase.Image_1.Show
      Endif
      aTypes   := { {'Database files (*.dbf)', '*.dbf'} }
      aTemp    := iif( !Empty(aNewFile),aNewFile[1],"")
      aNewFile := GetFile( aTypes, 'Select database files', CurDir(), .T. )
      If Empty(aNewFile)
         Aadd( aNewFile, aTemp )
      Endif
   Else
      AAdd( aNewFile, cDBF )
   Endif

   //aEval( aNewFile, {|x,i| MsgInfo ( x, ltrim( str ( i ) ) )} )

   IF !Empty(aNewFile)
       For nn := 1 to Len(aNewFile)
           If !Empty(aNewFile[nn]) .AND. Upper(Right(aNewFile[nn],3))="DBF"
                  If DB_Open( aNewFile[nn] )
                     _DBULastPath := hb_Curdrive()+':\'+CurDir()+'\'

                     If Used(aNewFile[nn])

                        Aadd( aFiles, aNewFile[nn] )
                        oWndBase.Title := PROGRAM+VERSION+COPYRIGHT+aNewfile[nn]

                        ArmMatrix()

                        cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
                        cBrowse_n := "Browse_"+cAreaPos
                        oWndBase.&(cBrowse_n).ColumnsAutoFitH
                        MuestraRec()
                        oWndBase.&(cBrowse_n).SetFocus             // Ilumina barra en primer registro
                     Endif

                  Endif

           Endif
       Next nn

   Else
      cBase := ''
      MuestraRec()
      oWndBase.Title := PROGRAM+VERSION+COPYRIGHT
      If !IsControlDefined(Tab_1,oWndBase)
         oWndBase.Image_1.Show
      Endif
   Endif

Return

*------------------------------------------------------------------------------*
Procedure ArmMatrix()
*------------------------------------------------------------------------------*
   Local i
   cBase := Alias() ; nCamp := Fcount() ; aEst  := DBstruct() ; aCtrl := {}
   aNomb := {'iif(deleted(),0,1)'} ; aJust := {0} ; aLong := {0} ; aFtype:={}
   cCtrl := "{},"

   For i := 1 to nCamp
       Aadd(aNomb,aEst[i,1])                             // Carga el nombre de campo
       Aadd(aJust,iif(aEst[i,2]=='N',1,0))               // Justifica a la izquierda o derecha de acuerdo al tipo de dato
       cCtrl += AssiCtrlBrw( aEst[i,2], aEst[i,3],aEst[i,4],FieldName(i) )   // control por tipo de campo
       Aadd(aLong,Max(100,Min(160,aEst[i,3]*14)))        // Asigna la longitud del dato en el browse
       If     aEst[i,2]=="I" .OR. aEst[i,2]=="W" .OR. aEst[i,2]=="Y" .OR. aEst[i,2]=="B"
              aEst[i,2]:= 'N'
       ElseIf aEst[i,2]=="G" .OR. aEst[i,2]=="P"
              aEst[i,2]:= 'M'
       ElseIf aEst[i,2]=="@" .OR. aEst[i,2]=="T"
              aEst[i,2]:= 'D'
       Endif
       Aadd(aFtype, aEst[i,2])                           // Carga el tipo de campo
   Next

   aCtrl :=  &("{"+cCtrl+"}")                            // Asigna controles por tipo de campo
   CreaBrowse( cBase, aNomb, aLong, aJust, aFtype, aCtrl )

Return

*------------------------------------------------------------------------------*
Function DB_Open( cFileDBF )
*------------------------------------------------------------------------------*
   lSuc := .F.
      TRY
          If ! ( DelExt(GetName(cFileDBF)) )->( Used() )
             Use ( cFileDBF ) New
             lSuc := .T.
             Aadd( aArea, ( Alias() )->( Select() ) )
             nArea++
             nBase++
          Endif
      CATCH loError
          MsgInfo("Unable open file: "+cFileDBF, PROGRAM+" TRY")
      END
Return (lSuc)

*---------------------------------------------------------------------*
FUNCTION GetName(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cName  := IF(EMPTY(nSlash), cTrim, SUBSTR(cTrim, nSlash + 1))
RETURN( cName )

*---------------------------------------------------------------------*
FUNCTION DelExt(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nDot   := RAT('.', cTrim)
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cNamew := IF(nDot <= nSlash .OR. nDot == nSlash + 1, ;
                  cTrim, LEFT(cTrim, nDot - 1))
RETURN( cNamew )


*------------------------------------------------------------------------------*
Function CreaBrowse( cBase, aNomb, aLong, aJust, aFtype, aCtrl )
*------------------------------------------------------------------------------*
    aHdr       := aClone(aNomb)
    aJst       := aClone(aJust)
    aHdr[1]    := ""
    aLong[1]   := 20
    aCabImg    := aClone(VerHeadIcon(aFtype))

    oWndBase.Image_1.Hide

    If IsControlDefined(Tab_1,oWndBase)
       NuevoTab()
    Else
       oWndBase  := GetExistingFormObject( "oWndBase" )
       DEFINE TAB Tab_1 OF oWndBase AT 40,15 WIDTH oWndBase:Clientwidth  - 30 HEIGHT oWndBase:Clientheight - 70 ;
       VALUE 1 FONT "Arial" SIZE 9 FLAT ON CHANGE SeleArea()
           PAGE cBase IMAGE "Main1"
                MakeBrowse()
           END PAGE
       END TAB

       oTab := GetControlObject("Tab_1","oWndBase")
       oTab:Anchor := "TOPLEFTBOTTOMRIGHT"

    Endif

    SetHeaderImages()

Return Nil

*------------------------------------------------------*
Procedure MakeBrowse()
*------------------------------------------------------*
   cAreaPos  := AllTrim( Str( ( Alias() )->( Select() ) ) )
   cBrowse_n := "Browse_"+cAreaPos
   oWndBase  := GetExistingFormObject( "oWndBase" )

           If !IsControlDefined(&cBrowse_n,oWndBase)

                  @ 26,0 BROWSE &cBrowse_n              ;
                     OF oWndBase                        ;
                     WIDTH  oWndBase:Clientwidth  - 32  ;
                     HEIGHT oWndBase:Clientheight - 100 ;
                     HEADERS aHdr                       ;
                     WIDTHS aLong                       ;
                     WORKAREA &( Alias() )              ;
                     FIELDS aNomb                       ;
                     VALUE 0                            ;
                     FONT "MS Sans Serif" SIZE 8        ;
                     TOOLTIP ""                         ;
                     ON CHANGE MuestraRec()             ;
                     IMAGE { "br_no", "br_ok" }         ;
                     JUSTIFY aJst                       ;
                     COLUMNCONTROLS aCtrl               ;
                     LOCK                               ;
                     EDIT                               ;
                     INPLACE                            ;
                     DELETE                             ;
                     ON HEADCLICK Nil                   ;
                     HEADERIMAGES aCabImg               ;
                     FULLMOVE                           ;
                     DOUBLEBUFFER

           Endif

   oBrowse := GetControlObject(cBrowse_n,"oWndBase")
   oBrowse:Anchor := "TOPLEFTBOTTOMRIGHT"

   nBrow++

Return

*------------------------------------------------------*
Procedure NuevoTab() // Cortesía: Ciro Vargas Clemow
*------------------------------------------------------*
   cAreaPos  := AllTrim( Str( aArea[nBase] ) )
   cBrowse_n := "Browse_"+cAreaPos

   oTab := GetControlObject("Tab_1","oWndBase")

      oTab:AddPage ( ( Alias() )->( Select() ), Alias() )
      nPage++
      oTab:Value := ( Alias() )->( Select() )

      MakeBrowse()

      oTab:AddControl( cBrowse_n, ( Alias() )->( Select() ), 26, 0 )

Return

*------------------------------------------------------*
Procedure SeleArea()
*------------------------------------------------------*
   If !Empty( Alias() )

      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      DBSelectArea( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) )
      cBase := Alias()

      If IsControlDefine(&(cbrowse_n),oWndBase)
         oWndBase.&(cBrowse_n).SetFocus          // Ilumina barra en primer registro
         MuestraRec()
      Endif

   Endif

Return

*------------------------------------------------------------------------------*
Procedure CierraBase()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      oTab      := GetControlObject("Tab_1","oWndBase")
      nPos      := ( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) )
      cAreaPos  := AllTrim( Str( ( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) ))
      cBrowse_n := "Browse_"+cAreaPos

      Set Index To

      If IsControlDefine( &(cBrowse_n), oWndBase )
         oWndBase.&(cBrowse_n).release
         Close ( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) )
         oTab:DeletePage ( oTab:value, oTab:caption( oTab:value ) )
         If oWndBase.Tab_1.ItemCount > 0
            DBSelectArea( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ))
            Titulo()
         Else
            Close data
            oWndBase.Tab_1.release
            aFiles   := {}
            aNewFile := {}
            nRecCopy := {}
            OpenBase("")
         Endif
      Else
         Close data
      Endif

   Endif

return

*------------------------------------------------------------------------------*
Procedure CierraAll()
*------------------------------------------------------------------------------*
   Local nc
   If !Empty( Alias() )
       For nc := 1 to oWndBase.Tab_1.ItemCount
           Close ( oWndBase.Tab_1.caption( nc ) )
       Next
       oWndBase.Tab_1.release
       aFiles   := {}
       aNewFile := {}
       nRecCopy := {}
       OpenBase("")
   Endif

Return

*------------------------------------------------------*
Function Iniciando()     // Cortesía: Fernando Yurisich
*------------------------------------------------------*
   oWndBase := GetExistingFormObject( "oWndBase" )
   oWndBase:AcceptFiles := .T.
   oWndBase:OnDropFiles := { |f| AEval( f, { |c| OpenBase( c ) } ) }
Return Nil

*------------------------------------------------------*
Function AssiCtrlBrw( cTypeField, nlongTot, nLongDec, cFieldName )
*------------------------------------------------------*

   cCtrlBrw := ""
   cComa    := iif( (FieldNum(cFieldName)<=FCount()-1),',','')

   If cTypeField=='L'
      //cCtrlBrw := "{'CHECKBOX','Yes','No'}"+cComa
      cCtrlBrw := "TGridControlLComboBox():New( 'Yes', 'No' )"+cComa
   Elseif cTypeField=='D'
      //cCtrlBrw := "{'DATEPICKER','UPDOWN'}"+cComa
      cCtrlBrw := "TGridControlDatePicker():New( .t., .t. )"+cComa
   Elseif cTypeField=='@' .OR. cTypeField=='T'
      cCtrlBrw := "{'TEXTBOX','DATE',''}"+cComa
      //cCtrlBrw := "{'TIMEPICKER','UPDOWN'}"+cComa
   Elseif cTypeField=='N' .OR. cTypeField=='I' .OR. cTypeField=='W' .OR. cTypeField=='Y' .OR. cTypeField=='B'
      cInpMsk  := iif( nLongDec > 0, REPLICATE( '9', nLongTot - nLongDec -1 ) + '.' + REPLICATE( '9', nLongDec ), REPLICATE( '9', nLongTot - nLongDec ) )
      cCtrlBrw := "{'TEXTBOX','NUMERIC','"+cInpMsk+"'}"+cComa
   Elseif cTypeField=='C'
//      cCtrlBrw := "{'TEXTBOX','CHARACTER','@A'}"+cComa
      cCtrlBrw := "{'TEXTBOX','CHARACTER',}"+cComa
   Elseif cTypeField=='M' .OR. cTypeField=='G' .OR. cTypeField=='P'
      cCtrlBrw := "{}"+cComa
      //cCtrlBrw := "TGridControlMemo():New('Edit Memo Field')"+cComa
   Else
      cCtrlBrw := "{}"+cComa
   Endif

Return( cCtrlBrw )

*------------------------------------------------------------------------------*
Procedure Adjust()
*------------------------------------------------------------------------------*
   Local na
   If IsControlDefine(Tab_1,oWndBase)
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      If IsControlDefine(&(cbrowse_n),oWndBase)
         For na := 1 to 255
             cBrowse_n := "Browse_"+AllTrim( Str(na) )
             If IsControlDefine(&(cbrowse_n),oWndBase)
                SetProperty( "oWndBase", cbrowse_n, "Width", oWndBase.width  - 40 )
                SetProperty( "oWndBase", cbrowse_n, "Height", oWndBase.height  - 152 )
             Endif
         Next
         oWndBase.Tab_1.width     := oWndBase.width  - 38
         oWndBase.Tab_1.Height    := oWndBase.height - 122
      Endif
   Endif
   If IsControlDefine(Image_1,oWndBase)
      oWndBase.Image_1.width   := oWndBase.width
      oWndBase.Image_1.height  := oWndBase.height - 122
   Endif
Return

*------------------------------------------------------------------------------*
Function VerHeadIcon( aTip )
*------------------------------------------------------------------------------*
   Local nv
   aFtype    := aClone( aTip )
   aHeadIcon := {"hdel"}

   For nv := 1 to FCount()
       Do Case
          Case aFType[nv]=='L'
               aadd(aHeadIcon,"hlogic")
          Case aFType[nv]=='D'
               aadd(aHeadIcon,"hfech")
          Case aFType[nv]=='@'
               aadd(aHeadIcon,"hfech")
          Case aFType[nv]=='N'
               aadd(aHeadIcon,"hnum")
          Case aFType[nv]=='B'
               aadd(aHeadIcon,"hnum")
          Case aFType[nv]=='I'
               aadd(aHeadIcon,"hnum")
          Case aFType[nv]=='C'
               aadd(aHeadIcon,"hchar")
          Case aFType[nv]=='M'
               aadd(aHeadIcon,"hmemo")
          Case aFType[nv]=='G'
               aadd(aHeadIcon,"hmemo")
          Case aFType[nv]=='T'
               aadd(aHeadIcon,"hfech")
          Case aFType[nv]=='P'
               aadd(aHeadIcon,"hmemo")
          Case aFType[nv]=='W'
               aadd(aHeadIcon,"hnum")
          Case aFType[nv]=='Y'
               aadd(aHeadIcon,"hnum")
          Otherwise
               aadd(aHeadIcon,"hchar")
       Endcase
   Next

Return( aHeadIcon )

*------------------------------------------------------------------------------*
Function SetHeaderImages()
*------------------------------------------------------------------------------*
   Local nc
//   atemp := Array( FCount()+1 )
//   Aeval( atemp, {|x,i| oWndBase.Browse_1.HeaderImages(i) := {i,(aJust[i]==1)}} )

   If !Empty( Alias() )

      For nc := 1 to oWndBase.Tab_1.ItemCount
          cAreaPos  := AllTrim( Str(nc) )
          cBrowse_n := "Browse_"+cAreaPos

          If IsControlDefined(&cBrowse_n,oWndBase)
             oWndBase.&(cBrowse_n).Fontname  := cFont
             oWndBase.&(cBrowse_n).Fontsize  := nSize
             oWndBase.&(cBrowse_n).fontcolor := aFntClr
             oWndBase.&(cBrowse_n).Backcolor := aBackClr
          Endif
      Next
   Endif

Return Nil

*------------------------------------------------------------------------------*
Function GetIndexInfo()
*------------------------------------------------------------------------------*
   LOCAL aInd:= {}, ig, cKey

   If !Empty( Alias() )
      FOR ig := 1 to 50
         IF ( cKey := ( Alias() )->( IndexKey( ig ) ) ) == ''
            EXIT
         ENDIF
         Aadd( aInd, "TAG "+( Alias() )->( OrdName( ig ) ) + ' : ' + "KEY " + cKey )
      NEXT
   Endif

RETURN aInd

*------------------------------------------------------------------------------*
Procedure SeleOrder()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->(OrdSetFocus(0))
   Endif
Return

*------------------------------------------------------------------------------*
Procedure IndexItems()
*------------------------------------------------------------------------------*
   Local ni
   If !Empty( Alias() )
      nTags := ( Alias() )->( OrdCount() )
      for ni = 1 to nTags
         if ! Empty( OrdName( ni ) )
            if ! Empty( OrdName( 1 ) )
               DbSetOrder( OrdName( 1 ) )
               DbGoTop()
            endif
            ITEM OrdName( ni ) ACTION  ( Alias() )->( DbSetOrder( OrdName(ni) ) )
         endif
      next
   Endif
Return

*------------------------------------------------------------------------------*
Procedure CopyRec(nOp)  // Copiar
*------------------------------------------------------------------------------*

   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

       If nOp = 1   // Selecciona registro
          RecReply()
          MuestraRec()
       Else         // Limpia Selección de registro
          nRecCopy := {}
          nRecSel := 0
          oWndBase.StatusBar.Item(2) := 'Selected Record: '
          Actualizar()
       Endif
   Endif
return

*------------------------------------------------------------------------------*
Function RecToMost()
*------------------------------------------------------------------------------*
   Local nr
   If Empty(nRecCopy)
      nRet := 0
   Else
      For nr := 1 to Len(nRecCopy)
          nRet := nRecCopy[ iif(AScan( nRecCopy[nr], nArea )>0, AScan( nRecCopy[nr], nArea ),1), 2 ]
      Next
   Endif
Return(nRet)

*------------------------------------------------------------------------------*
Function RecReply()
*------------------------------------------------------------------------------*
   cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
   cBrowse_n := "Browse_"+cAreaPos

   If Empty(nRecCopy)
      Aadd( nRecCopy, { ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ), oWndBase.&(cBrowse_n).Value } )
   Endif

Return Nil

*------------------------------------------------------------------------------*
procedure PasteRec() // Pegar
*------------------------------------------------------------------------------*
   local nPos   := 0, i := 1
   local aDatos := {}

   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      If Empty(nRecCopy)
         Msginfo('No Selected Record',PROGRAM)
      Else
        If ( Alias() )->( Select() ) = nRecCopy[ 1, 1 ]
           If MsgYesNo("This action will replace the current record"+Hb_OsNewLine()+"with the data of the selected record"+Hb_OsNewLine()+"Are you sure?",PROGRAM)
              nPos := oWndBase.&(cBrowse_n).Value
              ( Alias() )->( DBGoTo( nRecCopy[ 1, 2 ] ) )
              For i = 1 to ( Alias() )->( FCount() )
                  Aadd( aDatos, ( Alias() )->( Fieldget(i) ) )
              Next
              ( Alias() )->( DbGoTo( nPos) )
              ( Alias() )->( flock() )
              For i = 1 to ( Alias() )->( Fcount() )
                  ( Alias() )->( Fieldput( i, adatos[i] ) )
              Next
              ( Alias() )->( DbUnLock() )
              nRecSel  := 0
              nRecCopy := {}
              oWndBase.StatusBar.Item(2) := 'Selected Record: '
           Endif
        Endif
      EndIf
      Actualizar()
   Endif

Return

*------------------------------------------------------------------------------*
Function DBF_Idx()   // Indices de la base de datos
*------------------------------------------------------------------------------*
   Local ix
   lSalida := .t. ; k := 1 ; nVeces := 1
   aIndice       := {}
   aIndiceCampo  := {}

   Do while lSalida
      If ( (Alias() )->( OrdName( k ) ) == "" )
         lSalida := .f.
      Else
         cIndice := ( Alias() )->( OrdName( k ) )
         aAdd( aIndice, cIndice )
         cClave := Upper( (Alias() )->( OrdKey( k ) ) )
         For ix := 1 to FCount()
             If nVeces <= 1
                nInicio := At( FieldName(ix), cClave )
                If  nInicio != 0
                    aAdd( aIndiceCampo, ix )
                    nVeces++
                Endif
             Endif
         Next
      Endif
      k++
      nVeces := 1
   Enddo

   // Numero de indice
   If ( (Alias())->( ordSetFocus() ) == "" )
      nIndiceActivo := 1
   Else
      nIndiceActivo := AScan( aIndice, (Alias())->( OrdSetFocus() ) )
   Endif

   AutoMsgInfo( aIndice, "aIndice" )

Return(aIndiceCampo)

*------------------------------------------------------------------------------*
Procedure DeleteRecall()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      ( Alias() )->( DbGoto(oWndBase.&(cBrowse_n).Value) )

      if ( Alias() )->( Rlock() )
         iif( ( Alias() )->( Deleted() ), ( Alias() )->( DbRecall() ), ( Alias() )->( DbDelete() ) )
         siguiente()
      endif
      ( Alias() )->( dbUnlock() )
      Actualizar()

   Endif
Return

*------------------------------------------------------------------------------*
Procedure MuestraRec()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      nPos      := ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) )
      cAreaPos  := AllTrim( Str( ( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) ))
      cBrowse_n := "Browse_"+cAreaPos

      If !Empty(nRecCopy)
         nRecSel := Iif(nPos==nRecCopy[1,1],RecToMost(),0)
      Endif

      Titulo()

      oWndBase.StatusBar.Item(1) := ' Record: '      ;
      +padl(Alltrim(Str(oWndBase.&(cBrowse_n).Value)),7) ;
      +'/'+padl(Alltrim(Str(( Alias() )->(LastRec()))),7)
      oWndBase.StatusBar.Item(2) := 'Selected Record: '+ Alltrim(Str( nRecSel ,7))
      oWndBase.StatusBar.Item(3) := 'Index Tag: ' + ( Alias() )->( OrdName() )
      oWndBase.StatusBar.Item(4) := 'Order Key: ' + ( Alias() )->( OrdKey() )
   Else
      oWndBase.StatusBar.Item(1) := ''
   Endif
Return

*------------------------------------------------------------------------------*
Procedure Titulo()
*------------------------------------------------------------------------------*
   Local nPos := ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) )
   TRY
        oWndBase.Title := PROGRAM+VERSION+COPYRIGHT+iif(Empty(aFiles[nPos]),"",aFiles[nPos])
   CATCH loError
        oWndBase.Title := PROGRAM+VERSION+COPYRIGHT
   END
Return

*------------------------------------------------------------------------------*
Procedure primero()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->( DbGotop() )
      keybd_event(VK_HOME)
   Endif
return

*------------------------------------------------------------------------------*
Procedure anterior()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->( dBSkip ( -1 ) )
      keybd_event(VK_UP)
   Endif
return

*------------------------------------------------------------------------------*
Procedure siguiente()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->( dBSkip (1) )
      if  ( Alias() )->( recno() ) = ( Alias() )->( LastRec()+1 )
          ( Alias() )->( DbGoBottom() )
          keybd_event(VK_END)
      endif
      keybd_event(VK_DOWN)
   Endif
return

*------------------------------------------------------------------------------*
Procedure ultimo()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->( dbgobottom() )
      keybd_event(VK_END)
   Endif
return

*------------------------------------------------------------------------------*
Procedure Append()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      If IsControlDefine(&(cbrowse_n),oWndBase)
         Nuevo := .T.
         Administradbf( oWndBase.&(cBrowse_n).Value )
         Siguiente()
      Endif
   Endif
return
*------------------------------------------------------------------------------*
Procedure Edit()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos
      ( Alias() )->( DbGoto(oWndBase.&(cBrowse_n).Value) )
      oWndBase.&(cBrowse_n).Value := ( Alias() )->( RecNo() )
      oWndBase.&(cBrowse_n).SetFocus
   Endif
Return
*------------------------------------------------------------------------------*
Procedure JumpEdit(nOpt)
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      If nOpt == 1
         if Fcount() < 16
            EDIT WORKAREA ( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) )
         Else
            MsgInfo("EDIT does not display workarea with more than 16 Fields",PROGRAM)
         Endif
      Else
         EDIT EXTENDED WORKAREA ( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) )
      Endif
      Actualizar()
   Endif
Return

*------------------------------------------------------------------------------*
Procedure Actualizar()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

      oWndBase.&(cBrowse_n).SetFocus
      oWndBase.&(cBrowse_n).Refresh
   Endif
Return
*------------------------------------------------------------------------------*
Procedure MueveRec()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

      oWndBase.&(cBrowse_n).value := ( Alias() )->( Recno() )
   Endif
Return
*------------------------------------------------------------------------------*
Procedure PackBase()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      if MsgYesNo("Are you sure Pack Database?",PROGRAM)
         Pack
         Primero()
      Endif
   Endif
Return
*------------------------------------------------------------------------------*
Procedure ZapBase()
*------------------------------------------------------------------------------*
   If !Empty( Alias() )
      if MsgYesNo("DANGER!! - Are you sure Zap Database?",PROGRAM)
         Zap
         Actualizar()
      Endif
   Endif
Return
*------------------------------------------------------------------------------*
Procedure GoToRecord()
*------------------------------------------------------------------------------*
    Local VamosA
    If !Empty( Alias() )
       nUltimo := ( Alias() )->( LastRec() )
       VamosA := val(InputBox( 'Goto Record:' , PROGRAM ))
       VamosA := iif(VamosA>nUltimo,nUltimo,VamosA)
       If .Not. Empty(VamosA)
          ( Alias() )->( dbgoto(VamosA) )
          If VamosA == nUltimo
             Ultimo()
          Else
             MueveRec()
          Endif
       EndIf
    Endif
Return

*--------------------------------------------------------*
Procedure InsertRecord()
*--------------------------------------------------------*
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

      If MsgYesNo( "A blank record will be inserted before the current record!!!" + Hb_OSNewLine() + "Are You sure ?", "Insert Record")
         ( Alias() )->( DbGoTo( oWndBase.&(cBrowse_n).value ) )
         DbInsert(.T.)
         Actualizar()
      Endif
   Endif
Return

*--------------------------------------------------------*
Procedure BackColorBrowse()
*--------------------------------------------------------*
   Local nc
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

   If IsControlDefine(&(cbrowse_n),oWndBase)
      aBackClr := GetColor()
      For nc := 1 to oWndBase.Tab_1.ItemCount
          cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( nc ) ) ) ) )
          cBrowse_n := "Browse_"+cAreaPos
          oWndBase.&(cbrowse_n).Backcolor := aBackClr
      Next
      SaveArchIni(cBaseFolder+'\')
      Actualizar()
   Endif
   Endif
Return
*--------------------------------------------------------*
Procedure FontColorBrowse()
*--------------------------------------------------------*
   Local nc
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

   If IsControlDefine(&(cbrowse_n),oWndBase)
      aBackClr := GetColor()
      For nc := 1 to oWndBase.Tab_1.ItemCount
          cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( nc ) ) ) ) )
          cBrowse_n := "Browse_"+cAreaPos
          oWndBase.&(cbrowse_n).Fontcolor := aBackClr
      Next
      SaveArchIni(cBaseFolder+'\')
      Actualizar()
   Endif
   Endif
Return
*--------------------------------------------------------*
Procedure FontNameBrowse(nOpt)
*--------------------------------------------------------*
   Local nc
   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

   If IsControlDefine(&(cbrowse_n),oWndBase)
      if nOpt == 1
         aFont := GetFont()
         If !Empty(aFont[1])
            For nc := 1 to oWndBase.Tab_1.ItemCount
                cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( nc ) ) ) ) )
                cBrowse_n := "Browse_"+cAreaPos

                oWndBase.&(cbrowse_n).Fontname := aFont[1]
                oWndBase.&(cbrowse_n).Fontsize := aFont[2]
            Next
         Endif
      Else
         For nc := 1 to oWndBase.Tab_1.ItemCount
             cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( nc ) ) ) ) )
             cBrowse_n := "Browse_"+cAreaPos

             oWndBase.&(cbrowse_n).Fontname := 'MS Sans Serif'
             oWndBase.&(cbrowse_n).Fontsize := 8
         Next    
      Endif
      SaveArchIni(cBaseFolder+'\')
      Actualizar()
   Endif
   Endif
Return
*--------------------------------------------------------*
Procedure ExportData()
*--------------------------------------------------------*
   Local cExt, cSaveFile, cAlias, nRecno ,nIndex := 1

   If !Empty( Alias() )

        aFiles :={ {"DBF FoxPro files (*.dbf)", "*.dbf"} , ;
                   {"Text files (*.txt)"      , "*.txt"} , ;
                   {"CSV files (*.csv)"       , "*.csv"} , ;
                   {"SQL files (*.sql)"       , "*.sql"} , ;
                   {"Data files (*.dat)"      , "*.dat"} , ;
                   {"HTML files (*.html)"     , "*.html"}, ;
                   {"XML files (*.xml)"       , "*.xml"} , ;
                   {"Excel files (*.xls)"     , "*.xls"} , ;
                   {"Dbase III files (*.prg)" , "*.prg"} , ;
                   {"All files (*.*)"        , "*.*"  }  }

	cSaveFile := PutFile2( aFiles, , ,  )

	IF !Empty( cSaveFile )

	        If right(cSaveFile,3)=='dbf'
                   nIndex := 1
                   cExt :='dbf'
                Endif
                If right(cSaveFile,3)=='txt'
                   nIndex := 2
                   cExt :='txt'
                Endif
	        If right(cSaveFile,3)=='dat'
                   nIndex := 3
                   cExt :='dat'
                Endif
	        If right(cSaveFile,3)=='xls'
                   nIndex := 4
                   cExt :='xls'
                Endif
	        If right(cSaveFile,3)=='prg'
                   nIndex := 5
                   cExt :='prg'
                Endif
	        If right(cSaveFile,3)=='csv'
                   nIndex := 6
                   cExt :='csv'
                Endif
	        If right(cSaveFile,3)=='sql'
                   nIndex := 7
                   cExt :='sql'
                Endif
	        If right(cSaveFile,4)=='html'
                   nIndex := 8
                   cExt :='html'
                Endif
	        If right(cSaveFile,3)=='xml'
                   nIndex := 9
                   cExt :='xml'
                Endif

                MsgInfo(cSaveFile,PROGRAM)

		cSaveFile := IF( ( AT( ".", cSaveFile ) > 0 ), cSaveFile, ( cSaveFile + "." + cExt ) )

		IF File( cSaveFile )
			IF !MsgYesNo( cSaveFile + " already exists." + CRLF + ;
				"Overwrite existing file?" )
				Return
			ENDIF
 		ENDIF
		nRecno := ( Alias() )->( Recno() )
		( Alias() )->( DBGoTop() )
		IF nIndex = 2 .OR. nIndex = 3
			( Alias() )->( __dbSDF(.T.,(cSaveFile),{ },,,,,.F. ) )
		ELSEIF nIndex = 4
			SaveToXls( ( Alias() ), cSaveFile )
		ELSEIF nIndex = 5
			SaveToPrg( ( Alias() ), cSaveFile )
		ELSEIF nIndex = 6
                        COPY TO (cSaveFile) DELIMITED WITH ( { , ";" } )
		ELSEIF nIndex = 7
			Convert2Sql( ( Alias() ), cSaveFile )
		ELSEIF nIndex = 8
			dbf2html( cSaveFile )
		ELSEIF nIndex = 9
			dbf2xml( ( Alias() ), cSaveFile )
		ELSE
			( Alias() )->( __dbCopy((cSaveFile),{ },,,,,.F.,) )
		ENDIF
		( Alias() )->( DBGoto(nRecno) )
	ENDIF

   Endif

Return

*--------------------------------------------------------*
Procedure SaveToXls( cAlias, cFile )
*--------------------------------------------------------*
   Local oExcel,  oSheet, oBook, aColumns, nCell := 1

   If !Empty( Alias() )

//        IF ( oExcel := win_oleGetActiveObject("Excel.Application" )) == NIL
//           IF ( oExcel := win_oleCreateObject("Excel.Application" ) ) == NIL
           IF ( oExcel := CreateObject("Excel.Application" ) ) == NIL
              MsgStop( "ERROR! Excel is not available. ["+ Ole2TxtError()+ "]", PROGRAM )
              Return
           ENDIF
//        ENDIF

	oExcel:Visible := .F.
	oExcel:WorkBooks:Add()
	oSheet := oExcel:ActiveSheet

	Aeval( (cAlias)->( DBstruct(cAlias) ), { |e,i| oSheet:Cells( nCell, i ):Value := e[DBS_NAME] } )
	do while !(cAlias)->( EoF() )
		nCell++
		aColumns := (cAlias)->( Scatter() )
		aEval( aColumns, { |e,i| oSheet:Cells( nCell, i ):Value := e } )
		(cAlias)->( DBskip() )
	enddo

	oBook := oExcel:ActiveWorkBook
	oBook:Title   := cAlias
	oBook:Subject := cAlias
	oBook:SaveAs(cFile)
	oExcel:Quit()

   Endif

Return

#xtranslate fWriteLn( <xHandle>, <cString> ) ;
=> ;
            fWrite( <xHandle>, <cString> + CRLF )
*--------------------------------------------------------*
Procedure SaveToPrg( cAlias, cFile )
*--------------------------------------------------------*
   Local handle := fCreate(cFile, FC_NORMAL), nLen := Len( (cAlias)->( DBstruct(cAlias) ) )

   If !Empty( Alias() )

	fWriteLn(handle, "*-------------------------------------------------*")
	fWriteLn(handle, " PROCEDURE MAKE_DataBase()")
	fWriteLn(handle, "*-------------------------------------------------*")

	fWriteLn(handle, ' DBCREATE ("' + SubStr(cAlias, 1, RAT("_", cAlias) - 1) + '", {;')

	Aeval( (cAlias)->( DBstruct(cAlias) ), { |e,i| fWriteLn( handle, ;
		Chr(9) + '{ ' + padr('"' + e[DBS_NAME] + '",', 14) + '"' + Trim(e[DBS_TYPE]) + '",' + Str(e[DBS_LEN], 4) + ',' + Str(e[DBS_DEC], 3) + ;
		if(i < nLen, ' },;', ' }}, "'+( cAlias )->( RDDNAME() ) +'")') ) } )

	fWriteLn(handle, " RETURN")
	fClose(handle)

   Endif

Return
*--------------------------------------------------------*
Function Scatter()
*--------------------------------------------------------*
   Local aRecord[FCount()]
Return aEval( aRecord, {|x,n| aRecord[n] := FieldGet( n,x ) } )
*--------------------------------------------------------*
Function Gather( paRecord )
*--------------------------------------------------------*
Return aEval( paRecord, {|x,n| FieldPut( n, x ) } )

*--------------------------------------------------------*
Procedure PrintList()
*--------------------------------------------------------*
    Local aHdr1, aTot, aFmt, i

//    _OOHG_PRINTLIBRARY="HBPRINTER"
    _OOHG_PRINTLIBRARY="MINIPRINT"

    cBase := Alias()
    aEst  := DBstruct()

    aHdr  := {}
    aLen  := {}

    For i := 1 to ( Alias() )->(FCount())
        Aadd(aHdr,aEst[i,1])
        Aadd(aLen,Max(100,Min(160,aEst[i,3]*14)))
    Next

    If !Empty( cBase )

	aeval(aLen, {|e,i| aLen[i] := e/9})

	aHdr1 := array(len(aHdr))
	aTot  := array(len(aHdr))
	aFmt  := array(len(aHdr))
	afill(aHdr1, '')
	afill(aTot, .f.)
	afill(aFmt, '')

	set deleted on

	( Alias() )->( dbgotop() )

	DO REPORT ;
		TITLE    cBase                    ;
		HEADERS  aHdr1, aHdr              ;
		FIELDS   aHdr                     ;
		WIDTHS   aLen                     ;
		TOTALS   aTot                     ;
		NFORMATS aFmt                     ;
		WORKAREA &cBase                   ;
                LPP 60                            ;
                CPL 120                           ;
                LMARGIN  5                        ;
		PAPERSIZE DMPAPER_LETTER          ;
		PREVIEW

	Set Deleted off

    Endif

Return
/*
	DO REPORT ;
		TITLE    cBase                    ;
		HEADERS  aHdr1, aHdr              ;
		FIELDS   aHdr                     ;
		WIDTHS   aLen                     ;
		TOTALS   aTot                     ;
		NFORMATS aFmt                     ;
		WORKAREA &cBase                   ;
                LPP 60                            ;
                CPL 120                           ;
                LMARGIN  5                        ;
		PAPERSIZE DMPAPER_LETTER          ;
		PREVIEW
*/
*--------------------------------------------------------*
Procedure Salida()
*--------------------------------------------------------*

   if( MsgYesNo("Exit of DBF Viewer 2020?",PROGRAM), oWndBase.release, Nil )

Return

*--------------------------------------------------------*
Procedure OnlyDel(nOpt)
*--------------------------------------------------------*

   If !Empty( Alias() )
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

      ( Alias() )->( DbGoto(oWndBase.&(cBrowse_n).Value) )

      If nOpt = 1
         Set Filter to Deleted()
      Endif
      If nOpt = 2
         Set dele off
         Set Filter to !Deleted()
      Endif
      If nOpt = 3
         Set Filter to
      Endif

      go top
      Actualizar()
   Endif

Return
*------------------------------------------------------------*
PROCEDURE Unsorted
*------------------------------------------------------------*

   If !Empty( Alias() )
       SET INDEX TO
       SET ORDER TO
       GO TOP
       Actualizar()
   Endif

RETURN
*------------------------------------------------------------*
Procedure LoadArchIni(cPath)
*------------------------------------------------------------*
   cFont       := 'MS Sans Serif'
   nSize       := 8
   aFntClr     := {0,0,0}
   aBackClr    := {255,255,255}

   BEGIN INI FILE cpath+'dbview.ini'
         GET cFont     SECTION "Font"      ENTRY "Name"   DEFAULT cFont
         GET nSize     SECTION "Font"      ENTRY "Size"   DEFAULT nSize
         GET aFntClr   SECTION "Font"      ENTRY "Color"  DEFAULT aFntClr
         GET aBackClr  SECTION "Interface" ENTRY "Color"  DEFAULT aBackClr
   END INI

Return
*------------------------------------------------------------*
Procedure SaveArchIni(cPath)
*------------------------------------------------------------*
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

   BEGIN INI FILE cpath+'dbview.ini'
         SET SECTION "Font"      ENTRY "Name"  TO oWndBase.&(cBrowse_n).Fontname
         SET SECTION "Font"      ENTRY "Size"  TO oWndBase.&(cBrowse_n).Fontsize
         SET SECTION "Font"      ENTRY "Color" TO oWndBase.&(cBrowse_n).fontcolor
         SET SECTION "Interface" ENTRY "Color" TO oWndBase.&(cBrowse_n).Backcolor
   END INI

Return
*------------------------------------------------------------*
Procedure VerRegistro()
*------------------------------------------------------------*
   If !Empty( Alias() )
      If IsControlDefine(Tab_1,oWndBase)
         cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
         cBrowse_n := "Browse_"+cAreaPos
         If IsControlDefine(&(cbrowse_n),oWndBase)
            Administradbf( oWndBase.&(cbrowse_n).Value )
            Actualizar()
         Endif
      Endif
   Endif
Return

*--------------------------------------------------------*
Procedure DBQuery()
*--------------------------------------------------------*
   Local cField, cComp, cType := ""
   Local cChar := "", nNum := 0, dDate := ctod(""), nLog := 1
   Local cExpr := ""
   Local aQuery_ := {"", "", ""}
   Local aUndo_ := {}
   Local aFlds_ := {}
   Local aComp_ := { "== Equal", ;
                     "<> Not equal", ;
                     "<  Less than", ;
                     ">  Greater than", ;
                     "<= Less or equal", ;
                     ">= Greater or equal", ;
                     "() Contains", ;
                     "$  Is contained in", ;
                     '"" Is empty (Blank)' }

   Private cAlias, cDBFile


   If !Empty( ( Alias() ) )
	cDBFile := cFileNoPath(dbf())
	cAlias := Alias()
	IF !Empty(( Alias() )->( DbFilter() ))
		( Alias() )->( DbClearFilter() )
	ENDIF
	aEval(( Alias() )->( DBStruct() ), {|e| aAdd(aFlds_, e[DBS_NAME]) } )
	aAdd(aFlds_, "Deleted()") // Add this as if it were a logical field!

	cField := aFlds_[1]
	cComp := aComp_[1]

	DEFINE WINDOW Form_Query ;
		AT 0, 0 WIDTH 570 HEIGHT 305 ;
		TITLE PROGRAM+VERSION+"- Query" ;
		ICON 'MAIN1' ;
		MODAL ;
		ON INIT ( Form_Query.List_1.Setfocus, cType := GetType(cField, aFlds_, @cChar), ;
			Form_Query.Text_1.Enabled := ( cType == "C" ), ;
			Form_Query.Text_2.Enabled := ( cType == "N" ), ;
			Form_Query.Date_1.Enabled := ( cType == "D" ), ;
			Form_Query.Combo_1.Enabled := ( cType == "L" ) ) ;
		FONT "MS Sans Serif" ;
		SIZE 8


	    DEFINE FRAME Frame_1
            ROW    10
            COL    260
            WIDTH  290
            HEIGHT 135
            CAPTION "Value"
            OPAQUE .T.
	    END FRAME

	    DEFINE LABEL Label_1
            ROW    30
            COL    270
            WIDTH  60
            HEIGHT 20
            VALUE "Character"+":"
            VISIBLE .T.
	    END LABEL

	    DEFINE LABEL Label_2
            ROW    60
            COL    270
            WIDTH  60
            HEIGHT 20
            VALUE "Numeric"+":"
            VISIBLE .T.
	    END LABEL

	    DEFINE LABEL Label_3
            ROW    90
            COL    270
            WIDTH  60
            HEIGHT 20
            VALUE "Date"+":"
            VISIBLE .T.
	    END LABEL

	    DEFINE LABEL Label_4
            ROW    120
            COL    270
            WIDTH  60
            HEIGHT 20
            VALUE "Logical"+":"
            VISIBLE .T.
	    END LABEL

	    DEFINE LABEL Label_5
            ROW    6
            COL    12
            WIDTH  80
            HEIGHT 16
            VALUE "Field"
            VISIBLE .T.
	    END LABEL

	    DEFINE LABEL Label_6
            ROW    6
            COL    134
            WIDTH  120
            HEIGHT 16
            VALUE "Comparison"
            VISIBLE .T.
	    END LABEL

	    DEFINE LISTBOX List_1
            ROW    20
            COL    10
            WIDTH  114
            HEIGHT 130
            ITEMS aFlds_
            VALUE 1
            ONCHANGE ( cField := aFlds_[This.Value], cType := GetType(cField, aFlds_, @cChar), ;
			Form_Query.Text_1.Enabled := ( cType == "C" ), ;
			Form_Query.Text_2.Enabled := ( cType == "N" ), ;
			Form_Query.Date_1.Enabled := ( cType == "D" ), ;
			Form_Query.Combo_1.Enabled := ( cType == "L" ) )
            ONDBLCLICK Form_Query.Button_1.OnClick
            TABSTOP .T.
            VISIBLE .T.
            SORT .F.
            MULTISELECT .F.
	    END LISTBOX

	    DEFINE LISTBOX List_2
            ROW    20
            COL    132
            WIDTH  118
            HEIGHT 130
            ITEMS aComp_
            VALUE 1
            ONCHANGE cComp := aComp_[This.Value]
            ONLOSTFOCUS IF( CheckComp(cType, cComp), , Form_Query.List_2.Setfocus )
            ONDBLCLICK Form_Query.Button_1.OnClick
            TABSTOP .T.
            VISIBLE .T.
            SORT .F.
            MULTISELECT .F.
	    END LISTBOX

	    DEFINE EDITBOX Edit_1
            ROW    170
            COL    10
            WIDTH  240
            HEIGHT 100
            VALUE ""
            ONCHANGE ( cExpr := This.Value, ;
		Form_Query.Button_2.Enabled := ( !empty(cExpr) ), ;
		Form_Query.Button_8.Enabled := ( !empty(cExpr) ), ;
		Form_Query.Button_10.Enabled := ( !empty(cExpr) ) )
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            FONTBOLD .T.
            TABSTOP .T.
            VISIBLE .T.
	    END EDITBOX

	    DEFINE LABEL Label_7
            ROW    154
            COL    12
            WIDTH  100
            HEIGHT 16
            VALUE "Query expression"+":"
            VISIBLE .T.
	    END LABEL

	    DEFINE TEXTBOX Text_1
            ROW    26
            COL    340
            WIDTH  200
            HEIGHT 24
            ONCHANGE cChar := This.Value
            ONGOTFOCUS  Form_Query.Text_1.Enabled := ( cType == "C" )
            ONENTER ( Form_Query.Button_1.OnClick(), Form_Query.Button_8.Setfocus() )
            FONTBOLD .T.
            TABSTOP .T.
            VISIBLE .T.
            VALUE cChar
	    END TEXTBOX

	    DEFINE TEXTBOX Text_2
		ROW    56
		COL    340
	        WIDTH  200
		HEIGHT 24
	        NUMERIC .T.
		INPUTMASK "9999999.99"
	        RIGHTALIGN .T.
		MAXLENGTH 10
	        ONCHANGE nNum := This.Value
		ONGOTFOCUS Form_Query.Text_2.Enabled := ( cType == "N" )
	        ONENTER ( Form_Query.Button_1.OnClick(), Form_Query.Button_8.Setfocus() )
		FONTBOLD .T.
	        TABSTOP .T.
		VISIBLE .T.
	        VALUE nNum
	    END TEXTBOX

            DEFINE DATEPICKER Date_1
	        ROW    86
		COL    340
	        WIDTH  110
		HEIGHT 24
	        VALUE dDate
		SHOWNONE .T.
	        UPDOWN .T.
		ONCHANGE dDate := This.Value
	        ONGOTFOCUS Form_Query.Date_1.Enabled := ( cType == "D" )
		FONTBOLD .T.
	        TABSTOP .T.
		VISIBLE .T.
            END DATEPICKER

	    DEFINE COMBOBOX Combo_1
	        ROW    116
		COL    340
	        WIDTH  110
		HEIGHT 60
	        ITEMS {"True (.T.)", "False (.F.)"}
		VALUE nLog
	        ONCHANGE nLog := This.Value
		ONGOTFOCUS Form_Query.Combo_1.Enabled := ( cType == "L" )
	        ONENTER ( Form_Query.Button_1.OnClick(), Form_Query.Button_8.Setfocus() )
		FONTBOLD .T.
	        TABSTOP .T.
		VISIBLE .T.
	    END COMBOBOX

	    DEFINE BUTTON Button_1
	        ROW    156
		COL    260
	        WIDTH  136
		HEIGHT 24
	        CAPTION "Add"
		ACTION IF( CheckComp(cType, cComp), ( AddExpr(@cExpr, aUndo_, cField, cComp, ;
			iif(cType == "C", cChar, iif(cType == "N", nNum, ;
			iif(cType == "D", dDate, (nLog == 1))))), ;
			Form_Query.Button_2.Enabled := ( Len(aUndo_) > 0 ), ;
			Form_Query.Button_8.Enabled := ( !empty(cExpr) ), ;
			Form_Query.Button_10.Enabled := ( !empty(cExpr) ) ), Form_Query.List_2.Setfocus )
	        ONLOSTFOCUS Form_Query.Button_2.Enabled := ( Len(aUndo_) > 0 )
		TABSTOP .T.
	        VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_2
	        ROW    156
		COL    414
	        WIDTH  136
		HEIGHT 24
	        CAPTION "Undo"
		ACTION ( Undo(@cExpr, aUndo_), ;
			Form_Query.Button_2.Enabled := ( Len(aUndo_) > 0 ), ;
			Form_Query.Button_8.Enabled := ( !empty(cExpr) ), ;
			Form_Query.Button_10.Enabled := ( !empty(cExpr) ) )
	        ONLOSTFOCUS Form_Query.Button_2.Enabled := ( Len(aUndo_) > 0 )
		TABSTOP .T.
	        VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_3
		ROW    196
	        COL    260
		WIDTH  44
	        HEIGHT 24
		CAPTION ".and."
	        ACTION AddText(@cExpr, aUndo_, ".and. ")
		TABSTOP .T.
	        VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_4
	        ROW    196
		COL    321
	        WIDTH  44
		HEIGHT 24
	        CAPTION ".or."
		ACTION AddText(@cExpr, aUndo_, ".or. ")
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_5
	        ROW    196
		COL    383
	        WIDTH  44
		HEIGHT 24
	        CAPTION ".not."
		ACTION AddText(@cExpr, aUndo_, ".not. ")
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_6
	        ROW    196
		COL    444
	        WIDTH  44
		HEIGHT 24
	        CAPTION "("
		ACTION AddText(@cExpr, aUndo_, "( ")
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_7
	        ROW    196
		COL    505
	        WIDTH  44
		HEIGHT 24
	        CAPTION ")"
		ACTION AddText(@cExpr, aUndo_, " ) ")
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_8
	        ROW    236
		COL    260
	        WIDTH  62
		HEIGHT 24
	        CAPTION "Apply"
		ACTION IF( RunQuery(cExpr), Action_B9(), )
	        ONLOSTFOCUS Form_Query.Button_8.Enabled := ( !empty(cExpr) )
		TABSTOP .T.
	        VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_9
	        ROW    236
		COL    336
	        WIDTH  62
		HEIGHT 24
	        CAPTION "Close"
		ACTION  Action_B9()
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_10
	        ROW    236
		COL    412
	        WIDTH  62
		HEIGHT 24
	        CAPTION "Save"
		ACTION SaveQuery(cExpr, aQuery_,( Alias() ))
	        ONLOSTFOCUS Form_Query.Button_10.Enabled := ( !empty(cExpr) )
		TABSTOP .T.
	        VISIBLE .T.
	    END BUTTON

	    DEFINE BUTTON Button_11
	        ROW    236
		COL    488
	        WIDTH  62
		HEIGHT 24
	        CAPTION "Load"
		ACTION iif( LoadQuery(@cExpr, aQuery_,( Alias() )), ( aUndo_ := {}, ;
			Form_Query.Button_8.Enabled := ( !empty(cExpr) ), ;
			Form_Query.Button_10.Enabled := ( !empty(cExpr) ) ), )
	        TABSTOP .T.
		VISIBLE .T.
	    END BUTTON

            ON KEY ESCAPE ACTION IF( CheckComp(cType, cComp), Form_Query.Button_9.OnClick, Form_Query.List_2.Setfocus )

	END WINDOW

	Form_Query.Text_1.Enabled := .F.
	Form_Query.Text_2.Enabled := .F.
	Form_Query.Date_1.Enabled := .F.
	Form_Query.Combo_1.Enabled := .F.
	Form_Query.Button_2.Enabled := .F.
	Form_Query.Button_8.Enabled := .F.
	Form_Query.Button_10.Enabled := .F.

	CENTER WINDOW Form_Query
	ACTIVATE WINDOW Form_Query
	
	Primero()

   ENDIF

RETURN

Procedure Action_B9()
   Form_Query.Release
   Actualizar()
   Primero()
Return

*--------------------------------------------------------*
Procedure LimpiaFiltro()
*--------------------------------------------------------*
   If !Empty( ( Alias() ) )
      ( Alias() )->( DbClearFilter() )
      Actualizar()
      go top
    Endif
Return

*------------------------------------------------------------------------------*
Static Procedure Search_Replace( lReplace )
*------------------------------------------------------------------------------*
   Local aColumns := { FCount() }

   DEFAULT lReplace := .f.

   IF !Empty( Alias() )
	Private lFirstFind := .T., lFind := .T., cFind := "", cFindStr, cField, cAlias := Alias(), cReplStr, nCurRec

	Aeval( ( Alias() )->( DBstruct(( Alias() )) ), {|e| Aadd(aColumns, e[1])})

	DEFINE WINDOW Form_Find ;
		AT 0, 0 WIDTH 449 HEIGHT 222 ;
		TITLE IF(lReplace, PROGRAM+VERSION+"- Replace", PROGRAM+VERSION+"- Search") ;
		ICON 'MAIN1' ;
		MODAL ;
		ON INIT ( Form_Find.Combo_1.DisplayValue := "", Form_Find.Combo_2.DisplayValue := "", Form_Find.Combo_1.Setfocus ) ;
		FONT "MS Sans Serif" ;
		SIZE 8

		DEFINE LABEL Label_1
	        ROW    10
		COL    12
	        WIDTH  60
		HEIGHT 21
	        VALUE "Table:"
		VISIBLE .T.
	        AUTOSIZE .F.
		END LABEL

		DEFINE LABEL Label_11
	        ROW    10
		COL    95
	        WIDTH  240
		HEIGHT 21
	        VALUE ( Alias() )
		VISIBLE .T.
	        AUTOSIZE .F.
		END LABEL

		DEFINE LABEL Label_2
	        ROW    36
		COL    12
	        WIDTH  60
		HEIGHT 21
	        VALUE "Look for:"
		VISIBLE .T.
	        AUTOSIZE .F.
		END LABEL

		DEFINE COMBOBOX Combo_1
			ROW	32
			COL	95
			ITEMS aSearch
			VALUE nSearch
			WIDTH 240
			DISPLAYEDIT .T.
			ON DISPLAYCHANGE ( lFirstFind := .T., Form_Find.Button_1.Enabled := !Empty(Form_Find.Combo_1.DisplayValue) )
			ON CHANGE ( lFirstFind := .T., Form_Find.Button_1.Enabled := .t. )
			VISIBLE .T.
		END COMBOBOX

		DEFINE LABEL Label_3
	        ROW    62
		COL    12
	        WIDTH  80
		HEIGHT 18
	        VALUE "Replace with:"
		VISIBLE lReplace
	        AUTOSIZE .F.
		END LABEL

		DEFINE COMBOBOX Combo_2
			ROW	60
			COL	95
			ITEMS aReplace
			VALUE nReplace
			WIDTH 240
			DISPLAYEDIT .T.
			ON DISPLAYCHANGE ( Form_Find.Button_3.Enabled := !Empty(Form_Find.Combo_1.DisplayValue) .AND. !Empty(Form_Find.Combo_2.DisplayValue), ;
				Form_Find.Button_4.Enabled := !Empty(Form_Find.Combo_1.DisplayValue) .AND. !Empty(Form_Find.Combo_2.DisplayValue) )
			ON CHANGE ( Form_Find.Button_3.Enabled := .t., Form_Find.Button_4.Enabled := .t. )
			VISIBLE lReplace
		END COMBOBOX

		DEFINE FRAME Frame_1
	        ROW    92
		COL    12
	        WIDTH  98
		HEIGHT 92
		CAPTION "Direction"
	        OPAQUE .T.
		END FRAME

		DEFINE RADIOGROUP Radio_1
			ROW	104
			COL	22
			OPTIONS { "Forward" , "Backward" , "Entire scope" }
			VALUE nDirect
			WIDTH 82
			ONCHANGE ( nDirect := This.Value, lFirstFind := .T. )
			TABSTOP .T.
		END RADIOGROUP

		DEFINE LABEL Label_4
	        ROW    100
		COL    120
	        WIDTH  100
		HEIGHT 18
	        VALUE "Search in column:"
		VISIBLE .T.
	        AUTOSIZE .F.
		END LABEL

		DEFINE COMBOBOX Combo_3
			ROW	96
			COL	215
			ITEMS aColumns
			VALUE nColumns
			WIDTH 120
			ON CHANGE lFirstFind := .T.
		END COMBOBOX

		DEFINE CHECKBOX Check_1
			ROW	130
			COL	120
			WIDTH  260
			CAPTION "Match &case"
			VALUE lMatchCase
			ON CHANGE lFirstFind := .T.
		END CHECKBOX

		DEFINE CHECKBOX Check_2
			ROW	154
			COL	120
			WIDTH  260
			CAPTION "Match &whole word only"
			VALUE lMatchWhole
			ON CHANGE lFirstFind := .T.
		END CHECKBOX

		DEFINE BUTTON Button_1
	        ROW    10
		COL    350
	        WIDTH  80
		HEIGHT 24
	        CAPTION "&Find Next"
		ACTION FindNext(Form_Find.Combo_1.DisplayValue, Form_Find.Combo_3.Value, ; //MigSoft
			Form_Find.Check_1.Value, Form_Find.Check_2.Value)
	        TABSTOP .T.
		VISIBLE .T.
		END BUTTON

		DEFINE BUTTON Button_2
	        ROW    40
	        COL    350
		WIDTH  80
	        HEIGHT 24
		CAPTION "&Close"
	        ACTION ( ThisWindow.Release,(cAlias)->( RecNo() ) )
		TABSTOP .T.
	        VISIBLE .T.
		END BUTTON

		DEFINE BUTTON Button_3
	        ROW    70
		COL    350
	        WIDTH  80
		HEIGHT 24
	        CAPTION IF(lReplace, "&"+"Replace", "&Replace...")
		ACTION IF(lReplace, DoReplace(Form_Find.Combo_1.DisplayValue, Form_Find.Combo_2.DisplayValue, ;
			Form_Find.Combo_3.Value, Form_Find.Check_1.Value, Form_Find.Check_2.Value), ;
			( Form_Find.Button_3.Caption := "&"+"Replace", Form_Find.Button_3.Enabled := .f., ;
			Form_Find.Button_4.Visible := .t., Form_Find.Button_4.Enabled := .f., Form_Find.Label_3.Visible := .t., ;
			Form_Find.Combo_2.Visible := .t., ThisWindow.Title := PROGRAM+VERSION+"- Replace", Form_Find.Combo_1.Setfocus, lReplace := .t. ))
	        TABSTOP .T.
		VISIBLE .T.
		END BUTTON

		DEFINE BUTTON Button_4
	        ROW    100
		COL    350
	        WIDTH  80
		HEIGHT 24
	        CAPTION "Replace &All"
		ACTION DoReplace(Form_Find.Combo_1.DisplayValue, Form_Find.Combo_2.DisplayValue, ;
			Form_Find.Combo_3.Value, Form_Find.Check_1.Value, Form_Find.Check_2.Value, .t.)
	        TABSTOP .T.
		VISIBLE lReplace
		END BUTTON

		ON KEY RETURN ACTION IF(lReplace, Form_Find.Button_3.OnClick, Form_Find.Button_1.OnClick )
		ON KEY ESCAPE ACTION Form_Find.Button_2.OnClick

	END WINDOW

	Form_Find.Button_1.Enabled := .f.
	Form_Find.Button_3.Enabled := !lReplace
	Form_Find.Button_4.Enabled := !lReplace

	CENTER WINDOW Form_Find

	ACTIVATE WINDOW Form_Find

   ENDIF

Return

*------------------------------------------------------------------------------*
Static Procedure FindNext( cString, nField, lCase, lWhole )
*------------------------------------------------------------------------------*
   Local cAlias   := Alias()
   Local aColumns := (cAlias)->( DBstruct(cAlias) )
   Local nRecno   := (cAlias)->( RecNo() ), cType

	IF EMPTY(cString)
		Return
	ELSEIF ASCAN(aSearch, cString) == 0
		AADD(aSearch, cString)
		Form_Find.Combo_1.AddItem(cString)
	ENDIF
	IF !EMPTY(nField)
		nColumns := nField
	ENDIF
	lMatchCase := lCase
	lMatchWhole := lWhole

	lFind := .T.
	IF nField == 1
		cFind := ""
		IF lFirstFind
			lFirstFind := .F.
			IF nDirect == 3
				(cAlias)->( DbGotop() )
				DO WHILE !(cAlias)->( EoF() )
					cFindStr := IF(lCase, ALLTRIM(cString), UPPER(ALLTRIM(cString)))
					aColumns := (cAlias)->( Scatter() )
					Aeval(aColumns, {|x| cFind += XtoC(x) + " "})
					IF lCase
						IF cFindStr $ cFind
							EXIT
						ENDIF
					ELSE
						IF cFindStr $ UPPER(cFind)
							EXIT
						ENDIF
					ENDIF
					(cAlias)->( DbSkip() )
				ENDDO
				IF (cAlias)->( EoF() )
					lFind := .F.
					(cAlias)->( DbGoto(nRecno) )
					MsgInfo( "Can not find the string"+' "'+cString+'"' )
				ENDIF
			ELSEIF nDirect == 2
				(cAlias)->( DbSkip(-1) )
				DO WHILE !(cAlias)->( BoF() )
					cFindStr := IF(lCase, ALLTRIM(cString), UPPER(ALLTRIM(cString)))
					aColumns := (cAlias)->( Scatter() )
					Aeval(aColumns, {|x| cFind += XtoC(x) + " "})
					IF lCase
						IF cFindStr $ cFind
							EXIT
						ENDIF
					ELSE
						IF cFindStr $ UPPER(cFind)
							EXIT
						ENDIF
					ENDIF
					(cAlias)->( DbSkip(-1) )
				ENDDO
				IF (cAlias)->( BoF() )
					lFind := .F.
					(cAlias)->( DbGoto(nRecno) )
					MsgInfo( "Can not find the string"+' "'+cString+'"' )
				ENDIF
			ELSEIF nDirect == 1
				(cAlias)->( DbSkip() )
				DO WHILE !(cAlias)->( EoF() )
					cFindStr := IF(lCase, ALLTRIM(cString), UPPER(ALLTRIM(cString)))
					aColumns := (cAlias)->( Scatter() )
					Aeval(aColumns, {|x| cFind += XtoC(x) + " "})
					IF lCase
						IF cFindStr $ cFind
							EXIT
						ENDIF
					ELSE
						IF cFindStr $ UPPER(cFind)
							EXIT
						ENDIF
					ENDIF
					(cAlias)->( DbSkip() )
				ENDDO
				IF (cAlias)->( EoF() )
					lFind := .F.
					(cAlias)->( DbGoto(nRecno) )
					MsgInfo( "Can not find the string"+' "'+cString+'"' )
				ENDIF
			ENDIF
		ELSEIF lFind
			IF nDirect == 2
				(cAlias)->( DbSkip(-1) )
			ELSE
				(cAlias)->( DbSkip() )
			ENDIF
			DO WHILE !IF(nDirect = 2, (cAlias)->( BoF() ), (cAlias)->( EoF() ))
				cFindStr := IF(lCase, ALLTRIM(cString), UPPER(ALLTRIM(cString)))
				aColumns := (cAlias)->( Scatter() )
				Aeval(aColumns, {|x| cFind += XtoC(x) + " "})
				IF lCase
					IF cFindStr $ cFind
						EXIT
					ENDIF
				ELSE
					IF cFindStr $ UPPER(cFind)
						EXIT
					ENDIF
				ENDIF
				IF nDirect == 2
					(cAlias)->( DbSkip(-1) )
				ELSE
					(cAlias)->( DbSkip() )
				ENDIF
			ENDDO
			IF (cAlias)->( EoF() ) .OR. (cAlias)->( BoF() )
				lFind := .F.
				(cAlias)->( DbGoto(nRecno) )
				MsgInfo( "There are still no such records!" )
			ENDIF
		ENDIF
	ELSE
		cField := aColumns[nField-1][1]
		cType := aColumns[nField-1][2]
		IF cType $ "CND"
			IF cType == "C"
				IF lWhole
					cFindStr := cString
					cFind := "ALLTRIM((cAlias)->((&cField)))==M->cFindStr"
				ELSE
					cFindStr := IF(lCase, ALLTRIM(cString), UPPER(ALLTRIM(cString)))
					IF lCase
						cFind := "M->cFindStr $ (cAlias)->((&cField))"
					ELSE
						cFind := "M->cFindStr $ UPPER((cAlias)->((&cField)))"
					ENDIF
				ENDIF
			ELSEIF cType == "N"
				cFindStr := VAL(cString)
				cFind := "(cAlias)->((&cField))=M->cFindStr"
				cFind := "(cAlias)->((&cField))=M->cFindStr"
			ELSEIF cType == "D"
				cFindStr := CTOD(cString)
				cFind := "(cAlias)->((&cField))=M->cFindStr"
			ENDIF
			IF lFirstFind
				lFirstFind := .F.
				IF nDirect == 3
					(cAlias)->( __dbLocate({||(&cFind)},,,,.F.) )
					IF (cAlias)->( EoF() )
						lFind := .F.
						(cAlias)->( DbGoto(nRecno) )
						MsgInfo( "Can not find the string"+' "'+cString+'"' )
					ENDIF
				ELSEIF nDirect == 2
					(cAlias)->( DbSkip(-1) )
					DO WHILE !(cAlias)->( BoF() )
						IF &cFind
							EXIT
						ENDIF
						(cAlias)->( DbSkip(-1) )
					ENDDO
					IF (cAlias)->( BoF() )
						lFind := .F.
						(cAlias)->( DbGoto(nRecno) )
						MsgInfo( "Can not find the string"+' "'+cString+'"' )
					ENDIF
				ELSEIF nDirect == 1
					(cAlias)->( DbSkip() )
					(cAlias)->( __dbLocate({||(&cFind)},,,,.T.) )
					IF (cAlias)->( EoF() )
						lFind := .F.
						(cAlias)->( DbGoto(nRecno) )
						MsgInfo( "Can not find the string"+' "'+cString+'"' )
					ENDIF
				ENDIF
			ELSEIF lFind
				IF nDirect == 2
					(cAlias)->( DbSkip(-1) )
					DO WHILE !(cAlias)->( BoF() )
						IF &cFind
							EXIT
						ENDIF
						(cAlias)->( DbSkip(-1) )
					ENDDO
				ELSE
					(cAlias)->( __dbContinue() )
				ENDIF
				IF (cAlias)->( EoF() ) .OR. (cAlias)->( BoF() )
					lFind := .F.
					(cAlias)->( DbGoto(nRecno) )
					MsgInfo( "There are still no such records!" )
				ENDIF
			ENDIF
		ENDIF
	ENDIF

        cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
        cBrowse_n := "Browse_"+cAreaPos

	SetProperty( "oWndBase", cBrowse_n, "Value", (cAlias)->( RecNo() ) )
	DoMethod( "oWndBase", cBrowse_n, 'Refresh' )

Return

*------------------------------------------------------------------------------*
Static Procedure DoReplace(cString, cReplace, nField, lCase, lWhole, lAll)
*------------------------------------------------------------------------------*
   Local cAlias := Alias()
   Local aColumns := (cAlias)->( DBstruct(cAlias) ), cType, cFld, i, lReplace
   Local nRecno := (cAlias)->( RecNo() )

   DEFAULT lAll := .f.

	IF EMPTY(cString) .OR. EMPTY(cReplace)
		Return
	ELSEIF ASCAN(aReplace, cReplace) == 0
		AADD(aReplace, cReplace)
		Form_Find.Combo_2.AddItem(cString)
	ENDIF
	IF lAll
		IF ASCAN(aSearch, cString) == 0
			AADD(aSearch, cString)
			Form_Find.Combo_1.AddItem(cString)
		ENDIF
		IF nField == 1
			IF nDirect == 3
				(cAlias)->( DbGotop() )
				DO WHILE !(cAlias)->( EoF() )
					aColumns := (cAlias)->( Scatter() )
					For i := 1 To Len(aColumns)
						cFld := aColumns[i]
						IF cType == "N"
							lReplace := ( cFld = VAL(cString) )
							IF lReplace
								(cAlias)->&cField := VAL(cReplace)
							ENDIF
						ELSEIF cType == "D"
							lReplace := ( cFld = CTOD(cString) )
							IF lReplace
								(cAlias)->&cField := CTOD(cReplace)
							ENDIF
						ELSEIF Valtype( cFld ) == "C"
							IF lWhole
								lReplace := ( cFld == cString )
							ELSE
								IF lCase
									lReplace := cString $ cFld
								ELSE
									lReplace := UPPER(cString) $ UPPER(cFld)
								ENDIF
							ENDIF
							IF lReplace
								IF (cAlias)->( Rlock() )
									cField := (cAlias)->( Field(i) )
									(cAlias)->&cField := STRTRAN(cFld, cString, cReplace)
								ENDIF
								(cAlias)->( DBunlock() )
							ENDIF
						ENDIF
					Next
					(cAlias)->( DbSkip() )
				ENDDO
				(cAlias)->( DbGoto(nRecno) )
			ELSEIF nDirect == 2
				(cAlias)->( DbSkip(-1) )
				DO WHILE !(cAlias)->( BoF() )
					aColumns := (cAlias)->( Scatter() )
					For i := 1 To Len(aColumns)
						cFld := aColumns[i]
						IF cType == "N"
							lReplace := ( cFld = VAL(cString) )
							IF lReplace
								(cAlias)->&cField := VAL(cReplace)
							ENDIF
						ELSEIF cType == "D"
							lReplace := ( cFld = CTOD(cString) )
							IF lReplace
								(cAlias)->&cField := CTOD(cReplace)
							ENDIF
						ELSEIF Valtype( cFld ) == "C"
							IF lWhole
								lReplace := ( cFld == cString )
							ELSE
								IF lCase
									lReplace := cString $ cFld
								ELSE
									lReplace := UPPER(cString) $ UPPER(cFld)
								ENDIF
							ENDIF
							IF lReplace
								IF (cAlias)->( Rlock() )
									cField := (cAlias)->( Field(i) )
									(cAlias)->&cField := STRTRAN(cFld, cString, cReplace)
								ENDIF
								(cAlias)->( DBunlock() )
							ENDIF
						ENDIF
					Next
					(cAlias)->( DbSkip(-1) )
				ENDDO
				(cAlias)->( DbGoto(nRecno) )
			ELSEIF nDirect == 1
				(cAlias)->( DbSkip() )
				DO WHILE !(cAlias)->( EoF() )
					aColumns := (cAlias)->( Scatter() )
					For i := 1 To Len(aColumns)
						cFld := aColumns[i]
						IF cType == "N"
							lReplace := ( cFld = VAL(cString) )
							IF lReplace
								(cAlias)->&cField := VAL(cReplace)
							ENDIF
						ELSEIF cType == "D"
							lReplace := ( cFld = CTOD(cString) )
							IF lReplace
								(cAlias)->&cField := CTOD(cReplace)
							ENDIF
						ELSEIF Valtype( cFld ) == "C"
							IF lWhole
								lReplace := ( cFld == cString )
							ELSE
								IF lCase
									lReplace := cString $ cFld
								ELSE
									lReplace := UPPER(cString) $ UPPER(cFld)
								ENDIF
							ENDIF
							IF lReplace
								IF (cAlias)->( Rlock() )
									cField := (cAlias)->( Field(i) )
									(cAlias)->&cField := STRTRAN(cFld, cString, cReplace)
								ENDIF
								(cAlias)->( DBunlock() )
							ENDIF
						ENDIF
					Next
					(cAlias)->( DbSkip() )
				ENDDO
				(cAlias)->( DbGoto(nRecno) )
			ENDIF
		ELSE
			cField := aColumns[nField-1][1]
			cType := aColumns[nField-1][2]
			IF nDirect == 3
				(cAlias)->( DbGotop() )
				IF (cAlias)->( Flock() )
					cReplStr := cReplace
					cFindStr := ALLTRIM(cString)
					IF cType == "N"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := VAL(cReplStr)},{||(cAlias)->&(cField)=VAL(cFindStr)},,,,.F.) )
					ELSEIF cType == "D"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := CTOD(cReplStr)},{||(cAlias)->&(cField)=CTOD(cFindStr)},,,,.F.) )
					ELSE
						IF lWhole
							(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||(cAlias)->&(cField) == M->cFindStr},,,,.F.) )
						ELSE
							IF lCase
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||M->cFindStr $ (cAlias)->&(cField)},,,,.F.) )
							ELSE
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||UPPER(M->cFindStr) $ UPPER((cAlias)->&(cField))},,,,.F.) )
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ELSEIF nDirect == 2
				(cAlias)->( DbGotop() )
				IF (cAlias)->( Flock() )
					nCurRec := nRecno
					cReplStr := cReplace
					cFindStr := ALLTRIM(cString)
					IF cType == "N"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := VAL(cReplStr)},{||(cAlias)->&(cField)=VAL(cFindStr)},{||(cAlias)->( Recno() )<nCurRec},,,.F.) )
					ELSEIF cType == "D"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := CTOD(cReplStr)},{||(cAlias)->&(cField)=CTOD(cFindStr)},{||(cAlias)->( Recno() )<nCurRec},,,.F.) )
					ELSE
						IF lWhole
							(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||(cAlias)->&(cField) == M->cFindStr},{||(cAlias)->( Recno() )<nCurRec},,,.F.) )
						ELSE
							IF lCase
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||M->cFindStr $ (cAlias)->&(cField)},{||(cAlias)->( Recno() )<nCurRec},,,.F.) )
							ELSE
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||UPPER(M->cFindStr) $ UPPER((cAlias)->&(cField))},{||(cAlias)->( Recno() )<nCurRec},,,.F.) )
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ELSEIF nDirect == 1
				IF (cAlias)->( Flock() )
					cReplStr := cReplace
					cFindStr := ALLTRIM(cString)
					IF cType == "N"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := VAL(cReplStr)},{||(cAlias)->&(cField)=VAL(cFindStr)},,,,.T.) )
					ELSEIF cType == "D"
						(cAlias)->( DBEval({||(cAlias)->&(cField) := CTOD(cReplStr)},{||(cAlias)->&(cField)=CTOD(cFindStr)},,,,.T.) )
					ELSE
						IF lWhole
							(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||(cAlias)->&(cField) == M->cFindStr},,,,.T.) )
						ELSE
							IF lCase
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||M->cFindStr $ (cAlias)->(&(cField))},,,,.T.) )
							ELSE
								(cAlias)->( DBEval({||(cAlias)->&(cField) := STRTRAN((cAlias)->&(cField), cFindStr, cReplStr)},{||UPPER(M->cFindStr) $ UPPER((cAlias)->&(cField))},,,,.T.) )
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			(cAlias)->( DBunlock() )
			(cAlias)->( DbGoto(nRecno) )
		ENDIF
	ELSE
		lFind := .T.
		FindNext( cString, nField, lCase, lWhole )
		IF nField == 1
			IF lFind
				aColumns := (cAlias)->( Scatter() )
				For i := 1 To Len(aColumns)
					cFld := aColumns[i]
					IF Valtype( cFld ) == "C"
						IF lCase
							lReplace := cString $ cFld
						ELSE
							lReplace := UPPER(cString) $ UPPER(cFld)
						ENDIF
						IF lReplace
							IF (cAlias)->( Rlock() )
								cField := (cAlias)->( Field(i) )
								(cAlias)->&cField := STRTRAN(cFld, cString, cReplace)
							ENDIF
							(cAlias)->( DBunlock() )
						ENDIF
					ENDIF
				Next
			ENDIF
		ELSE
			cField := aColumns[nField-1][1]
			cType := aColumns[nField-1][2]
			IF lFind .AND. cType $ "CND"
				IF (cAlias)->( Rlock() )
					IF cType == "N"
						(cAlias)->&cField := VAL(cReplace)
					ELSEIF cType == "D"
						(cAlias)->&cField := CTOD(cReplace)
					ELSE
						(cAlias)->&cField := cReplace
					ENDIF
				ENDIF
			ENDIF
			(cAlias)->( DBunlock() )
		ENDIF
	ENDIF

        cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
        cBrowse_n := "Browse_"+cAreaPos

	SetProperty( "oWndBase", cBrowse_n, "Value", (cAlias)->( RecNo() ) )
	DoMethod( "oWndBase", cBrowse_n, 'Refresh' )

Return

*------------------------------------------------------------------------------*
Static Procedure AppendCopy()
*------------------------------------------------------------------------------*
   Local aCurrent

   IF !Empty(( Alias() ))
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

        go oWndBase.&(cBrowse_n).Value
	aCurrent := (( Alias() ))->( Scatter() )
	IF (( Alias() ))->( Rlock() )
		(( Alias() ))->( DBappend() )
		(( Alias() ))->( Gather(aCurrent) )
	ENDIF
	(( Alias() ))->( DBunlock() )
	Ultimo()
   ENDIF

Return

*--------------------------------------------------------*
Static Procedure DeleteAll()
*--------------------------------------------------------*
   Local nRecNo

   IF !Empty(( Alias() ))
	nRecNo := (( Alias() ))->( RecNo() )
	(( Alias() ))->( dbGoTop() )
	DO WHILE !(( Alias() ))->( Eof() )
		IF (( Alias() ))->( Rlock() )
			(( Alias() ))->( DBDelete() )
		ENDIF
		(( Alias() ))->( DBskip() )
	ENDDO
	(( Alias() ))->( DBunlock() )
	//SetProperty( "oWndBase", "Browse_1", "Value", nRecNo )
	//DoMethod( "oWndBase", "Browse_1", 'Refresh' )
        //Go top
        Primero()
   ENDIF

Return

Function AdjustColumn(nOpt)
   IF !Empty(( Alias() ))
      cAreaPos  := AllTrim( Str( ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) ) ) )
      cBrowse_n := "Browse_"+cAreaPos

      Do Case
         Case nOpt = 1
              oWndBase.&(cBrowse_n).ColumnsAutoFitH
         Case nOpt = 2
              oWndBase.&(cBrowse_n).ColumnsAutoFit
         Case nOpt = 3
*             oWndBase.&(cBrowse_n).ColumnsBetterAutoFit
	      DoMethod( "oWndBase", cBrowse_n, 'ColumnsBetterAutoFit' )
       Endcase
   Endif
Return Nil

*--------------------------------------------------------*
Static Procedure UnDeleteAll()
*--------------------------------------------------------*
   Local nRecNo

   IF !Empty(( Alias() ))
	nRecNo := (( Alias() ))->( RecNo() )
	(( Alias() ))->( dbGoTop() )
	DO WHILE !(( Alias() ))->( Eof() )
		IF (( Alias() ))->( Rlock() )
			(( Alias() ))->( DBRecall() )
		ENDIF
		(( Alias() ))->( DBskip() )
	ENDDO
	(( Alias() ))->( DBunlock() )
	//SetProperty( "oWndBase", "Browse_1", "Value", nRecNo )
	//DoMethod( "oWndBase", "Browse_1", 'Refresh' )
        //Go top
        Primero()
   ENDIF

Return

/*

This is a Clipper 5.x function which emulates dBase's INSERT command.  I
believe it's as fast as it can be for pure Clipper code, but feel free to
improve upon it if you can (and let me know what you did).

Todd MacDonald

*/

//--------------------------------------------------------------------------//
  FUNCTION dbInsert( lBefore )
//--------------------------------------------------------------------------//

/*

Syntax

  dbInsert( [<lBefore>] )  ->  nil

Arguments

  <lBefore> is true if you wish to insert the record before the current
  record, false (or not passed) if after.

Returns

  nil

Description

  dbInsert emulates the dBase INSERT command by appending a blank record
  at the end of the current file and "moving" all the records down leaving
  a blank record at the current position (or current position + 1 depending
  on the value of <lBefore>).

Examples

  #command INSERT [<b4: BEFORE>] => dbInsert( <.b4.> )

  use WHATEVER

  INSERT BEFORE

Author

  Todd C. MacDonald

Notes

  This function is an original work and is placed into the Public Domain by 
  the author.

History

  05/19/92 TCM Created
  05/20/92 TCM Bug fix: Added code to carry each record's deleted status 
               forward when the record is "moved".  
  05/21/92 TCM Bug fix: Fixed the aeval responsible for blanking out the 
               "inserted" record so that it really *does* blank it out.

*/

#define DBS_NAME  1
#define FLD_BLK   1
#define FLD_VAL   2

LOCAL nRec     := recno() + 1
LOCAL lSavDel  := SET( _SET_DELETED, .f. )
LOCAL nSavOrd  := indexord()
LOCAL aFields  := {}
LOCAL lDeleted := .f.

IF lBefore = nil; lBefore := .f.; ENDIF

IF lBefore

  // stop moving records when the current record is reached
  --nRec

ENDIF

// build the array of field get/set blocks with cargo space for field values
aeval( dbstruct(), { | a | ;
  aadd( aFields, { fieldblock( a[ DBS_NAME ] ), nil } ) } )

// process in physical order for speed
dbsetorder( 0 )

// add a new record at eof
dbappend()

// back up through the file moving records down as we go
WHILE recno() > nRec

  // store all values from previous record in the appropriate cargo space
  dbskip( -1 )
  aeval( aFields, { | a | a[ FLD_VAL ] := eval( a[ FLD_BLK ] ) } )

  // save deleted status
  lDeleted := deleted()

  // replace all values in next record with stored cargo values
  dbskip()
  aeval( aFields, { | a | eval( a[ FLD_BLK ], a[ FLD_VAL ] ) } )

  // set deleted status
  iif( lDeleted, dbdelete(), dbrecall() )

  // go to previous record
  dbskip( -1 )

END

// blank out the "inserted" record
aeval( aFields, { | a, cType | ;
  cType := valtype( eval( a[ FLD_BLK ] ) ), ;
  eval( a[ FLD_BLK ], ;
    iif( cType $ 'CM', '', ;
    iif( cType = 'N',  0, ;
    iif( cType = 'D',  ctod( '  /  /  ' ), ;
    iif( cType = 'L',  .f., nil ) ) ) ) ) } )

// make sure it's not deleted
dbrecall()

// leave things the way we found them
dbsetorder( nSavOrd )
SET( _SET_DELETED, lSavDel )

RETURN nil

*-----------------------------------------------------------------------------*
Function Putfile2 ( aFilter, title, cIniFolder, nochangecurdir, cFileName )
*-----------------------------------------------------------------------------*
   local c := '' , n

   Default aFilter := {}, cFileName := ""

   FOR n := 1 TO Len( aFilter )
      c += aFilter[n][1] + Chr(0) + aFilter[n][2] + Chr(0)
   NEXT

Return C_PutFile ( c, title, cIniFolder, nochangecurdir, cFileName )

*-----------------------------------------------------------------------------*
Function Convert2Sql( cAlias, cSaveFile )
*-----------------------------------------------------------------------------*
   LOCAL i, cSqlCreate, cSqlDatos, cSqlCampos, nHandle, TABULADOR := Chr(9)

   If Empty( cSaveFile )
      MsgInfo('You must choose a file to convert','Warning')
   Else
      cSqlCreate := 'CREATE TABLE '+(cAlias) + ' ('+ CRLF

      For i := 1 to LEN(aEst)
          cSqlCreate += TABULADOR + aEst[i,DBS_NAME]+' '
          DO CASE
             CASE aEst[i,DBS_TYPE] = 'C'
                  cSqlCreate+= 'varchar('+alltrim(str(aEst[i,DBS_LEN]))+')'
             CASE aEst[i,DBS_TYPE] = 'N'
                  if aEst[i,DBS_DEC] > 0
                     cSqlCreate += 'numeric('+alltrim(str(aEst[i,DBS_LEN]))+','+alltrim(str(aEst[i,DBS_DEC]))+')'
                  else
                     cSqlCreate += 'integer'
                  endif
             CASE aEst[i,DBS_TYPE] = 'D'
                  cSqlCreate+= 'date'
             CASE aEst[i,DBS_TYPE] = 'L'
                  cSqlCreate+= 'char(1)'
             CASE aEst[i,DBS_TYPE] = 'M'
                  cSqlCreate+= 'blob'
          ENDCASE

          If i < LEN(aEst)
             cSqlCreate+= ','+CRLF  // , exception de last
          else
             cSqlCreate+= CRLF
          endif

      Next

      cSqlCreate += ');'

      // the data
      cSqlCampos := 'INSERT INTO '+(cAlias)+' ('

      For i := 1 to LEN(aEst)
          cSqlCampos+= aEst[i,DBS_NAME]
          If i < LEN(aEst)
             cSqlCampos+= ','  // , exception de last
          endif
      next

      cSqlCampos += ') VALUES ('
      cSqlDatos := ''

      (cAlias)->(DbGoTop())

      While !(cAlias)->(Eof())
            cSqlDatos += cSqlCampos
            For i := 1 to LEN(aEst)
                cCampo := aEst[i,DBS_NAME]
                DO CASE
                   CASE aEst[i,DBS_TYPE] = 'C' .or. aEst[i,DBS_TYPE] = 'M'
                        cSqlDatos += "'"+ alltrim((cAlias)->&cCampo) +"'"
                   CASE aEst[i,DBS_TYPE] = 'N'
                        cSqlDatos += alltrim(str((cAlias)->&cCampo))
                   CASE aEst[i,DBS_TYPE] = 'D'
                        If Empty((cAlias)->&cCampo)
                           cSqlDatos += 'NULL'
                        Else
                           cSqlDatos += "'"+ FormatDate((cAlias)->&cCampo) + "'"
                        Endif
                   CASE aEst[i,DBS_TYPE] = 'L'
                        cSqlDatos += "'"+ if((cAlias)->&cCampo,'S','N') + "'"
                ENDCASE
                If i < LEN(aEst)
                   cSqlDatos += ','  // , exception the last
                Endif
            Next
            cSqlDatos += ');'+CRLF
            (cAlias)->(DbSkip())
      End

      nHandle := FCreate( cSaveFile, FC_NORMAL )
      FWrite(nHandle, cSqlCreate)
      FWrite(nHandle, CRLF)
      FWrite(nHandle, CRLF)
      FWrite(nHandle, cSqlDatos)
      FClose(nHandle)
      
      If File( cSaveFile )
         MsgInfo( "File created: " + cSaveFile )
      Else
         MsgInfo( "Error: ", FError() )
      Endif

   Endif

RETURN Nil

*-----------------------------------------------------------------------------*
Function Convert2SqlF( cAlias, cSaveFile )   // FireBird
*-----------------------------------------------------------------------------*
   LOCAL i, cSqlCreate, cSqlDatos, cSqlCampos, nHandle, TABULADOR := Chr(9)

   If Empty( cSaveFile )
      MsgInfo('You must choose a file to convert','Warning')
   Else
      cSqlCreate := 'CREATE TABLE '+(cAlias) + ' ('+ CRLF

      For i := 1 to LEN(aEst)
          cSqlCreate += TABULADOR + aEst[i,DBS_NAME]+' '
          DO CASE
             CASE aEst[i,DBS_TYPE] = 'C'
                  cSqlCreate+= 'varchar('+alltrim(str(aEst[i,DBS_LEN]))+')'
             CASE aEst[i,DBS_TYPE] = 'N'
                  if aEst[i,DBS_DEC] > 0
                     cSqlCreate += 'numeric('+alltrim(str(aEst[i,DBS_LEN]))+','+alltrim(str(aEst[i,DBS_DEC]))+')'
                  else
                     cSqlCreate += 'integer'
                  endif
             CASE aEst[i,DBS_TYPE] = 'D'
                  cSqlCreate+= 'date'
             CASE aEst[i,DBS_TYPE] = 'L'
                  cSqlCreate+= 'char(1)'
             CASE aEst[i,DBS_TYPE] = 'M'
                  cSqlCreate+= 'blob'
          ENDCASE

          If i < LEN(aEst)
             cSqlCreate+= ','+CRLF  // , exception de last
          else
             cSqlCreate+= CRLF
          endif

      Next

      cSqlCreate += ');'

      // the data
      cSqlCampos:= 'INSERT INTO '+(cAlias)+' ('

      For i := 1 to LEN(aEst)
          cSqlCampos+= aEst[i,DBS_NAME]
          If i < LEN(aEst)
             cSqlCampos+= ','  // , exception de last
          endif
      next

      cSqlCampos += ') VALUES ('
      cSqlDatos := ''

      (cAlias)->(DbGoTop())

      While !(cAlias)->(Eof())
            cSqlDatos += cSqlCampos
            For i := 1 to LEN(aEst)
                cCampo := aEst[i,DBS_NAME]
                DO CASE
                   CASE aEst[i,DBS_TYPE] = 'C' .or. aEst[i,DBS_TYPE] = 'M'
                        cSqlDatos += "'"+ alltrim((cAlias)->&cCampo) +"'"
                   CASE aEst[i,DBS_TYPE] = 'N'
                        cSqlDatos += alltrim(str((cAlias)->&cCampo))
                   CASE aEst[i,DBS_TYPE] = 'D'
                        If Empty((cAlias)->&cCampo)
                           cSqlDatos += 'NULL'
                        Else
                           cSqlDatos += "'"+ FormatDate((cAlias)->&cCampo) + "'"
                        Endif
                   CASE aEst[i,DBS_TYPE] = 'L'
                        cSqlDatos += "'"+ if((cAlias)->&cCampo,'S','N') + "'"
                ENDCASE
                If i < LEN(aEst)
                   cSqlDatos += ','  // , exception the last
                Endif
            Next
            cSqlDatos += ');'+CRLF
            (cAlias)->(DbSkip())
      End

      cSqlDatos += CRLF+'COMMIT WORK;'+CRLF

      nHandle := FCreate( cSaveFile, FC_NORMAL )
      FWrite(nHandle, cSqlCreate)
      FWrite(nHandle, CRLF)
      FWrite(nHandle, CRLF)
      FWrite(nHandle, cSqlDatos)
      FClose(nHandle)

   Endif

RETURN Nil

*-----------------------------------------------------------------------------*
FUNCTION FormatDate(dFecha)
*-----------------------------------------------------------------------------*
/* dada una variable tipo fecha devuelve un string con este formato:
   AAAA-MM-DD.
   Dicho formato es necesario para las consultas de firebird
*/
RETURN substr(dtos(dFecha),1,4)+'-'+substr(dtos(dFecha),5,2)+'-'+substr(dtos(dFecha),7,2)

*-----------------------------------------------------------------------------*
PROCEDURE Dbf2Html ( cSaveFile )
*-----------------------------------------------------------------------------*
   LOCAL oDoc, oNode, oTable, oRow, oCell
   LOCAL i, j

If !Empty( cSavefile )

   //USE ( cDbf )

   oDoc          := THtmlDocument():new()

   /* Operator "+" creates a new node */
   oNode         := oDoc:head + "meta"
   oNode:name    := "Generator"
   oNode:content := "THtmlDocument"

   /* Operator ":" returns first "h1" from body (creates if not existent) */
   oNode         := oDoc:body:h1
   oNode:text    := "DBF Viewer 2020"

   /* Operator "+" creates a new <p> node */
   oNode         := oDoc:body + "p"

   /* Operator "+" creates a new <font> node with attribute */
   oNode         := oNode   + 'font size="5"'
   // oNode:text    := alias()

   /* Operator "+" creates a new <b> node */
   oNode         := oNode   + "b"

   /* Operator "+" creates a new <font> node with attribute */
   oNode         := oNode   + "font color='blue'"
   oNode:text    := Alias()+ ".DBF "

   /* Operator "-" closes 2nd <font>, result is <b> node */
   oNode         := oNode   - "font"

   /* Operator "-" closes <b> node, result is 1st <font> node */
   oNode         := oNode   - "b"

   oNode:text    := "database!"

   /* Operator "-" closes 1st <font> node, result is <p> node */
   oNode         := oNode   - "font"

   oNode         := oNode   + "hr"
   HB_SYMBOL_UNUSED( oNode )

   /* Operator ":" returns first "table" from body (creates if not existent) */
   oTable        := oDoc:body:table
   oTable:attr   := 'border="0" width="100%" cellspacing="0" cellpadding="0"'

   oRow          := oTable  + 'tr bgcolor="lightcyan"'
   FOR i := 1 TO FCount()
      oCell     := oRow + "th"
      oCell:text := FieldName( i )
      oCell     := oCell - "th"
      HB_SYMBOL_UNUSED( oCell )
   NEXT

   oRow := oRow - "tr"
   HB_SYMBOL_UNUSED( oRow )

   FOR i := 1 TO LastRec()
      oRow         := oTable + "tr"
      oRow:bgColor := iif( RecNo() % 2 == 0, "lightgrey", "white" )

      FOR j := 1 TO FCount()
         oCell      := oRow + "td"
         oCell:text := FieldGet( j )
         oCell      := oCell - "td"
         HB_SYMBOL_UNUSED( oCell )
      NEXT

      oRow := oRow - "tr"
      HB_SYMBOL_UNUSED( oRow )

      SKIP
   NEXT

   oNode := oDoc:body  + "hr"
   HB_SYMBOL_UNUSED( oNode )
   oNode := oDoc:body  + "p"

   oNode:text := "Records from database " + Alias() + ".dbf"

   IF oDoc:writeFile( cSaveFile )
      MsgInfo( "File created: " + cSaveFile )
   ELSE
      MsgInfo( "Error: ", FError() )
   ENDIF

   //HtmlToOem( oDoc:body:getText() )
   HtmlToOem( oDoc:body:getText() )

Endif

RETURN

/*---------------------------------------------------------
 * Dbf2XML Version 1.0
 * This program converts a dbf file to xml file
 * Author : Yamil Bracho, Caracas, Venezuela
 *          brachoy@pdvsa.com
 * Date   : Nov 2000
 *
 * Revised: 7/29/02 Added special character processing.
 *          Fixed a few bugs. James Bott. jbott@compuserve.com
 * Revised: v1.1 12-aug-2009, Pete Disdale.
 *	    Converted for S87 (crudely...)
 *	    Added metadata node for DBF recreation
 * Modified: v1.2 15-jun-2012, MigSoft
 *          Adapted for ooHG - mig2soft/at/yahoo.com
 *
 */
Function Dbf2Xml( cDbf, cSaveFile )

PRIVATE cFile

        // global string defs
	tab = chr(9)
	tab2 = chr(9) + chr(9)
	tab3 = chr(9) + chr(9) + chr(9)
	xmlver = '<?xml version="1.0"?>'
	meta_start_tag = "<metadata>"
	meta_end_tag = "</metadata>"
	data_start_tag = "<data>"
	data_end_tag = "</data>"

        // DBF field defs
	col_start_tag = "<column>"
	col_end_tag = "</column>"
	name_start_tag = "<name>"
	name_end_tag = "</name>"
	type_start_tag = "<type>"
	type_end_tag = "</type>"
	width_start_tag = "<width>"
	width_end_tag = "</width>"
	decs_start_tag = "<decimals>"
	decs_end_tag = "</decimals>"

        // DBF record defs
	row_start_tag = "<row>"
	row_end_tag = "</row>"

  cFile = LOWER (cDbf)
  IF At (".dbf", cFile) == 0
    cFile = cFile + ".dbf"
  ENDIF

  IF !File( cFile )
     MsgInfo(cFile + " does not exist!!!")
     Return Nil
  ENDIF

  GenXML( cFile, cSaveFile )

  If File( cSaveFile )
     MsgInfo( "File created: " + cSaveFile )
  Else
     MsgInfo( "Error: ", FError() )
  Endif

RETURN Nil

*/---------------------------------------------------------
*/ Generates the file
*/---------------------------------------------------------
FUNCTION GenXML( cDbf, cSaveFile )

  PRIVATE fldname, fldtype, fldsize, flddecs
  PRIVATE cBuffer
  PRIVATE cFile
  PRIVATE cValue
  PRIVATE nHandle
  PRIVATE nFields
  PRIVATE nField
  PRIVATE nPos

  cFile  = cSaveFile

  IF EMPTY (ALIAS())
     MsgInfo("Error opening " + cDbf)
     Return Nil
  ENDIF

  nHandle = fCreate (cFile, 0)
  IF nHandle < 0
     MsgInfo("Error creating " + cFile)
     MsgInfo("nHandle = " + alltrim(str(nhandle)))
     Return Nil
  ENDIF

  //------------------
  // Writes XML header
  //------------------
  fWrite( nHandle, xmlver + crlf )

  // root tag
  fWrite( nHandle, make_start_tag (cDbf) + crlf )

  nFields = FCOUNT()
  DECLARE fldname [nfields], fldtype [nfields], fldsize [nfields], flddecs [nfields]
  AFIELDS (fldname, fldtype, fldsize, flddecs)

  cBuffer = tab + make_comment ("DBF structure info") + crlf + ;
	    tab + meta_start_tag  + crlf
  fWrite( nHandle, cBuffer )

  FOR nField = 1 TO nFields
    fWrite (nHandle, tab2 + col_start_tag + crlf)
    cBuffer = tab3 + name_start_tag + fldname [nField] + name_end_tag + crlf + ;
	      tab3 + type_start_tag + fldtype [nField] + type_end_tag + crlf + ;
	      tab3 + width_start_tag + alltrim (str (fldsize [nField])) + width_end_tag + crlf + ;
	      tab3 + decs_start_tag + alltrim (str (flddecs [nField])) + decs_end_tag + crlf
    fWrite( nHandle, cBuffer )
    fWrite (nHandle, tab2 + col_end_tag + crlf)
  NEXT nField

  cBuffer = tab + meta_end_tag	+ crlf + ;
	    tab + make_comment ("DBF table data") + crlf + ;
	    tab + data_start_tag  + crlf
  fWrite( nHandle, cBuffer )

  old_percent = -1

  DO WHILE !Eof()
    cBuffer = tab2 + row_start_tag  + crlf
    fWrite( nHandle, cBuffer )

    FOR nField = 1 TO nFields

       //-------------------
       // Beginning Record Tag
       //-------------------

       thisfld = fldname [nfield]
       cBuffer = tab3 + make_start_tag (thisfld)

       DO CASE
	 CASE fldtype[nField] == "D"
	   cValue = Dtos (&thisfld)

	 CASE fldtype[nField] == "N"
	   cValue = Str (&thisfld)

	 CASE fldtype[nField] == "L"
	   cValue = IIf( &thisfld, "true", "false" )

	 OTHERWISE
	   cValue = &thisfld.
	   //--- Convert special characters
	   cValue = strTran(cValue,"&","&amp;")
	   cValue = strTran(cValue,"<","&lt;")
	   cValue = strTran(cValue,">","&gt;")
	   cValue = strTran(cValue,"'","&apos;")
	   cValue = strTran(cValue,["],[&quot;])
       ENDCASE

       cBuffer	= cBuffer + alltrim (cValue) + ;
		  make_end_tag (thisfld) + crlf

       fWrite( nHandle, cBuffer )
    NEXT nField

    //------------------
    // Ending Record Tag
    //------------------
    fWrite (nHandle, tab2 + row_end_tag  + crlf)
    SKIP

  ENDDO

  cBuffer = tab + data_end_tag + crlf + ;
	    make_end_tag (cDbf) + crlf
  fWrite( nHandle, cBuffer )


RETURN FCLOSE (nHandle)

*/------------------------------------------------
*/ create a "start" tag with value "node"
*/------------------------------------------------
FUNCTION make_start_tag( node )
RETURN "<" + node + ">"

*/------------------------------------------------
*/ create an "end" tag with value "node"
*/------------------------------------------------
FUNCTION make_end_tag( node )
RETURN "</" + node + ">"

*/------------------------------------------------
*/ create a comment tag with value "text"
*/------------------------------------------------
FUNCTION make_comment( text )
RETURN "<!-- " + text + " -->"

*------------------------------------------------------------------------------*
Function WhatCvsVer()
*------------------------------------------------------------------------------*
   Local oFile, cLine, aCvs := {}

   oFile := TFileRead():New( "ChangeLog." )
   oFile:Open()
   If oFile:Error()
      MsgStop( oFile:ErrorMsg( "FileRead: " ) )
   Else
      oFile:ReadLine()
      cLine := AllTrim( oFile:ReadLine() )
      If Upper( Left( cLine, 16 ) ) == "* $ID: CHANGELOG"
         Aadd( aCvs, Ltrim( Substr( cLine, 20, 5 ) ) )
         Aadd( aCvs, Ltrim( Substr( cLine, 28, 8 ) ) )
      Endif
   Endif
   oFile:Close()

Return( aCvs )
