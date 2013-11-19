/*
 * $Id: Admindbf.Prg,v 1.1 2013-11-19 19:15:41 migsoft Exp $
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

#include 'oohg.ch'
#include "dbuvar.ch"

PROCEDURE AdministraDBF( nReg )

Public aName := {}, aCtrol := {}, nOpt := 1 , nReg1:=nReg, aTxtBx := {}

   If !Empty( Alias() )

       nAlto := CalcHeight()

       DEFINE WINDOW Win_2                                ;
           AT 0,0                                         ;
           WIDTH 685                                      ;
           HEIGHT 570                                     ;
           TITLE PROGRAM+VERSION+' - Record View #'+Alltrim(Str(RecNo()));
           ICON "MAIN1"                                   ;
           MODAL                                          ;
           FONT 'ARIAL' SIZE 9                            ;
           NOSIZE                                         ;
           NOMAXIMIZE                                     ;
           ON INIT ( DesactivarEdicion(), Actualizar2(), iif(Nuevo,Nuevo(),) ) ;
           ON RELEASE CerrarTablas()

           AbrirTablas()

           Define Splitbox
               MyToolBar()
           End Splitbox

               @ 32,8 FRAME FRAME_51 WIDTH 657 HEIGHT 460

               Define Window Win_1                          ;
                   at 40,10                                 ;
                   width 650                                ;
                   height 450                               ;
                   virtual height MAX(nAlto-70,451)         ;
                   INTERNAL                                 ;
                   nocaption                                ;
                   font "ms sans serif" size 9              ;
                   focused

                   CreaControles()

               End Window

           @ 500,450 BUTTON ACEPTAR  CAPTION 'O&K'     PICTURE "guardar1" ACTION AceptarEdicion()
           @ 500,550 BUTTON CANCELAR CAPTION 'Ca&ncel' PICTURE "salir1"   ACTION CancelarEdicion()

       END WINDOW

       CENTER WINDOW Win_2
       ACTIVATE WINDOW Win_2

   Endif

RETURN

*------------------------------------------------------------*
Function CalcHeight()
*------------------------------------------------------------*
   nAlto1 := 140

   For n := 1 to Fcount()
       If ValType(&(Fieldname(n)))=='M'
          nAlto1 := nAlto1 + 58
       Endif
   Next

   nAlto1 := nAlto1 + ( FCount() * 30 )

Return(nAlto1)

*------------------------------------------------------------*
PROCEDURE CreaControles()
*------------------------------------------------------------*
   Local nFil:=10, nCol:=180; nLong:=400

   @ nFil,10 FRAME FRAME_1 WIDTH 620 HEIGHT MAX(nAlto - 90, 138)

   aLabel := {}  ; aCtrol := {} ; aName := {} ; aTxtBx := {}

   aDBstru  := DBstruct()

   For n := 1 to FCount()

       aadd( aLabel , "label_" + alltrim( str(n) ) )
       aadd( aCtrol , "Control_" + alltrim( str(n) ) )
       aadd( aName  , Fieldname(n) )
       nLongTot := aDBstru[n,3] ; nLongDec := aDBstru[n,4]
       @ nFil+(n*30),20 LABEL &(aLabel[n]) VALUE aName[n]+" ("+alltrim(str(nLongTot,6,0))+")" WIDTH nCol - 30

       If ValType(&(aName[n]))=='L'
          @ nFil+(n*30) ,nCol CHECKBOX   &(aCtrol[n]) caption "Yes" value &(aName[n])
          Aadd( aTxtBx, .F. )
       Elseif ValType(&(aName[n]))=='D'
          @ nFil+(n*30) ,nCol DATEPICKER &(aCtrol[n]) value &(aName[n]) UpDown SHOWNONE
          Aadd( aTxtBx, .F. )
       Elseif ValType(&(aName[n]))=='N'
          cInpMsk  := iif( nLongDec > 0, REPLICATE( "9", nLongTot - nLongDec -1 ) + "." + REPLICATE( "9", nLongDec ), REPLICATE( "9", nLongTot - nLongDec ) )
          nWidthF  := Min( iif(len(str(&(aName[n])))*10<40,40,len(str(&(aName[n])))*10),nLong )
          @ nFil+(n*30) ,nCol TEXTBOX &(aCtrol[n]) WIDTH nWidthF VALUE &(aName[n]) NUMERIC INPUTMASK cInpMsk RIGHTALIGN
          Aadd( aTxtBx, .T. )
       Elseif ValType(&(aName[n]))=='C'
          @ nFil+(n*30) ,nCol TEXTBOX    &(aCtrol[n]) value &(aName[n]) width Min( iif(len(&(aName[n]))*10<40,40,len(&(aName[n]))*10),nLong )
          Aadd( aTxtBx, .T. )
       Elseif ValType(&(aName[n]))=='M'
          @ nFil+(n*30) ,nCol EDITBOX    &(aCtrol[n]) value &(aName[n]) width nLong height 81
          nFil := nFil + 58
          Aadd( aTxtBx, .F. )
       Endif

   Next

Return

*------------------------------------------------------------*
PROCEDURE MyToolbar()
*------------------------------------------------------------*

   DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 16,16 FONT "Arial" SIZE 9 FLAT

      BUTTON PRIMERO TOOLTIP '&First' PICTURE 'first1'	;
      ACTION ( dBGoTop() ,Actualizar2() )

      BUTTON ANTERIOR TOOLTIP '&Previous' PICTURE 'previous1'	;
      ACTION ( dBSkip ( -1 ),Actualizar2() )

      BUTTON SIGUIENTE TOOLTIP '&Next' PICTURE 'next1'	;
      ACTION ( dBSkip (1) , if ( Eof() , DbGoBottom() , Nil ) ,Actualizar2() )

      BUTTON ULTIMO TOOLTIP '&Last' PICTURE 'last1'	;
      ACTION ( dBGoBottom (),Actualizar2()  )  SEPARATOR

      BUTTON BUSCAR TOOLTIP '&Find' PICTURE 'find1'	;
      ACTION Buscando()

      BUTTON Nuevo TOOLTIP '&New' PICTURE 'new1'	;
      ACTION ( Nuevo := .T. , Nuevo() )

      BUTTON EDITAR TOOLTIP '&Edit' PICTURE 'format1'	;
      ACTION iif( LastRec()>0,  If ( BloquearRegistro() , ActivarEdicion() , Nil ) , )

      BUTTON ELIMINAR TOOLTIP 'E&rase' PICTURE 'erase1'	;
      ACTION Eliminar()

      BUTTON IMPRIMIR TOOLTIP '&Print'PICTURE 'print1' ;
      ACTION Imprimir()

      BUTTON CERRAR TOOLTIP '&Close' PICTURE 'down1' ;
      ACTION Win_2.release

   END TOOLBAR

RETURN

*------------------------------------------------------------*
PROCEDURE Buscando()
*------------------------------------------------------------*
If !Empty( Alias() )

   nAlto := CalcHeight()

   DEFINE WINDOW Win_Busca2                           ;
       AT 0,0                                         ;
       WIDTH 685                                      ;
       HEIGHT 550                                     ;
       TITLE PROGRAM+VERSION+' - Record Find'         ;
       ICON "MAIN1"                                   ;
       MODAL                                          ;
       NOSIZE                                         ;
       NOMAXIMIZE                                     ;
       FONT 'ARIAL' SIZE 9

           Define Window Win_Busca1                    ;
              width 650                                ;
              height 450                               ;
              virtual height MAX(nAlto-70,451)         ;
              INTERNAL                                 ;
              nocaption                                ;
              font "ms sans serif" size 9              ;
              focused

              CreaControles()
              Nuevo2()

           End Window

       @ 470,420 BUTTON ACEPTAR  CAPTION 'O&K'     PICTURE "guardar1" ACTION AceptaBuscar()
       @ 470,530 BUTTON CANCELAR CAPTION 'Ca&ncel' PICTURE "salir1"   ACTION CancelaBuscar()

    END WINDOW

    CENTER WINDOW Win_Busca2
    ACTIVATE WINDOW Win_Busca2

Endif

Return
*------------------------------------------------------------*
PROCEDURE AbrirTablas
*------------------------------------------------------------*

   Go nReg1

RETURN
*------------------------------------------------------------*
PROCEDURE CerrarTablas
*------------------------------------------------------------*

RETURN
*------------------------------------------------------------*
PROCEDURE DesactivarEdicion
*------------------------------------------------------------*

   For n := 1 to FCount()
       If aTxtBx[n] == .T.
          Win_1.&(aCtrol[n]).ReadOnly := .T.
       Else
          Win_1.&(aCtrol[n]).Enabled := .F.
       Endif
   Next

   Win_2.Aceptar.Enabled		:= .F.
   Win_2.Cancelar.Enabled		:= .F.
   Win_2.ToolBar_1.Enabled		:= .T.

RETURN
*------------------------------------------------------------*
PROCEDURE ActivarEdicion
*------------------------------------------------------------*

   For n := 1 to FCount()
       If aTxtBx[n] == .T.
          Win_1.&(aCtrol[n]).ReadOnly := .F.
       Else
          Win_1.&(aCtrol[n]).Enabled := .T.
       Endif
   Next

   Win_2.Aceptar.Enabled		:= .T.
   Win_2.Cancelar.Enabled		:= .T.
   Win_2.ToolBar_1.Enabled		:= .F.

   Win_1.&(aCtrol[1]).SetFocus

RETURN
*------------------------------------------------------------*
PROCEDURE CancelarEdicion()
*------------------------------------------------------------*

   DesactivarEdicion()
   Actualizar2()

   ( Alias() )->( dbUnlock() )

   Nuevo := .F.

RETURN
*------------------------------------------------------------*
PROCEDURE AceptarEdicion()
*------------------------------------------------------------*

   DesactivarEdicion()

   If Nuevo == .T.
      (Alias())->(DbAppend())
      Nuevo := .F.
   EndIf

   For n := 1 to FCount()
       (Alias())->&(aName[n]) := Win_1.&(aCtrol[n]).Value
   Next

   UNLOCK

RETURN

*------------------------------------------------------------*
PROCEDURE CancelaBuscar()
*------------------------------------------------------------*

    Win_Busca2.Release

RETURN

*------------------------------------------------------------*
PROCEDURE AceptaBuscar()
*------------------------------------------------------------*

   For n := 1 to FCount()
       If !Empty( Win_Busca1.&(aCtrol[n]).Value ) .and. IsControlDefined ( &(aCtrol[n]), Win_Busca1 )
           cNomb := FieldName(n)
           If ValType( &(cNomb) )=="C" .OR. ValType( &(cNomb) )=="M"
              Busca := Upper(Win_Busca1.&(aCtrol[n]).Value)
              Locate for Upper( &( cNomb ) ) = ( Busca )
           Else
              Busca := Win_Busca1.&(aCtrol[n]).Value
              Locate for &( cNomb ) = ( Busca )
           Endif
           If Found()
              nRegBus := (Alias())->(Recno())
              Go nRegBus
              Actualizar2()
           Else
              MsgExclamation( 'No records for your query!', PROGRAM )
           EndIf
        Endif
   Next
   Win_Busca2.Release

Return
*------------------------------------------------------------*
PROCEDURE Nuevo()
*------------------------------------------------------------*

   For n := 1 to FCount()
       aadd( aCtrol , "Control_" + alltrim( str(n) ) )
       aadd( aName  , Fieldname(n) )

       If ValType(&(aName[n]))=='L'
          Win_1.&(aCtrol[n]).value := .F.
       Elseif ValType(&(aName[n]))=='D'
          Win_1.&(aCtrol[n]).value := ctod("  /  /  ")
       Elseif ValType(&(aName[n]))=='N'
          Win_1.&(aCtrol[n]).value := 0
       Elseif ValType(&(aName[n]))=='C'
          Win_1.&(aCtrol[n]).value := ''
       Elseif ValType(&(aName[n]))=='M'
          Win_1.&(aCtrol[n]).value := ''
       Endif
   Next

   ActivarEdicion()

RETURN

*------------------------------------------------------------*
PROCEDURE Nuevo2()
*------------------------------------------------------------*

   For n := 1 to FCount()
       aadd( aCtrol , "Control_" + alltrim( str(n) ) )
       aadd( aName  , Fieldname(n) )

       If ValType(&(aName[n]))=='L'
          Win_Busca1.&(aCtrol[n]).value := .F.
       Elseif ValType(&(aName[n]))=='D'
          Win_Busca1.&(aCtrol[n]).value := ctod("  /  /  ")
       Elseif ValType(&(aName[n]))=='N'
          Win_Busca1.&(aCtrol[n]).value := 0
       Elseif ValType(&(aName[n]))=='C'
          Win_Busca1.&(aCtrol[n]).value := ''
       Elseif ValType(&(aName[n]))=='M'
          Win_Busca1.&(aCtrol[n]).value := ''
       Endif
   Next

RETURN

*------------------------------------------------------------*
PROCEDURE Actualizar2()
*------------------------------------------------------------*

   Win_2.TITLE := PROGRAM+VERSION+' - Record View #'+Alltrim(Str(RecNo()))

   For n := 1 to FCount()
       Win_1.&(aCtrol[n]).Value := (Alias())->&(aName[n])
   Next

Return

*------------------------------------------------------------*
Function BloquearRegistro()
*------------------------------------------------------------*
   Local RetVal

   If (Alias())->(RLock())
      RetVal := .t.
   Else
      MsgExclamation ('This record is edited by another user. Retry Later')
      RetVal := .f.
   EndIf

Return RetVal

*------------------------------------------------------------*
Procedure Eliminar
*------------------------------------------------------------*
   If MsgYesNo ( 'Are you sure?',PROGRAM)
      If BloquearRegistro()
         (Alias())->(dbdelete())
         (Alias())->(dbgotop())
         Actualizar2()
      EndIf
   EndIf
Return

*------------------------------------------------------------*
Procedure Imprimir()
*------------------------------------------------------------*

   PrintList()

/*
    Local aHdr := aClone(aNomb)
    Local aLen := aClone(aLong)
    Local aHdr1, aTot, aFmt

    If !Empty( cbase )

	aeval(aLen, {|e,i| aLen[i] := e/9})
	adel(aLen, 1)
	asize(aLen, len(aLen)-1)
	adel(aHdr, 1)
	asize(aHdr, len(aHdr)-1)
	adel(aHdr, len(aHdr))
	asize(aHdr, len(aHdr)-1)
	asize(aLen, len(aLen)-1)
	aHdr1 := array(len(aHdr))
	aTot  := array(len(aHdr))
  	aFmt  := array(len(aHdr))
	afill(aHdr1, '')
	afill(aTot, .f.)
	afill(aFmt, '')

	set deleted on

	( cBase )->( dbgotop() )

	DO REPORT ;
		TITLE    cBase + ' Database List' ;
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

	set deleted off

    Endif
*/
Return
