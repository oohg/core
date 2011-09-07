/*
 * $Id: h_activex.prg,v 1.10 2011-09-07 19:06:17 fyurisich Exp $
 */
/*
 * ooHG source code:
 * ActiveX control
 *
 *  Marcelo Torres, Noviembre de 2006.
 *  TActiveX para [x]Harbour Minigui.
 *  Adaptacion del trabajo de:
 *  ---------------------------------------------
 *  Lira Lira Oscar Joel [oSkAr]
 *  Clase TActiveX_FreeWin para Fivewin
 *  Noviembre 8 del 2006
 *  email: oscarlira78@hotmail.com
 *  http://freewin.sytes.net
 *  @CopyRight 2006 Todos los Derechos Reservados
 *  ---------------------------------------------
 *  Implemented by ooHG team.
 *
 * + Soporte de Eventos para los controles activeX [oSkAr] 20070829
 *
 *
 */

#include "oohg.ch"
#include "hbclass.ch"

//-----------------------------------------------------------------------------------------------//
CLASS TActiveX FROM TControl
   DATA Type      INIT "ACTIVEX" READONLY
   DATA nWidth    INIT nil
   DATA nHeight   INIT nil
   DATA oOle      INIT nil
   DATA cProgId   INIT ""
   DATA hSink     INIT nil
   DATA hAtl      INIT nil

   METHOD Define
   METHOD Release

   DELEGATE Set TO oOle
   DELEGATE Get TO oOle
   ERROR HANDLER __Error

   DATA aAxEv        INIT {}              // oSkAr 20070829
   DATA aAxExec      INIT {}              // oSkAr 20070829
   METHOD EventMap( nMsg, xExec, oSelf )  // oSkAr 20070829

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, cProgId, ;
               NoTabStop, lDisabled ) CLASS TActiveX
*-----------------------------------------------------------------------------*
LOCAL nStyle, oError, nControlHandle, bErrorBlock, hSink

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm )

   ASSIGN ::nWidth  VALUE ::nWidth  TYPE "N" DEFAULT ::Parent:Width
   ASSIGN ::nHeight VALUE ::nHeight TYPE "N" DEFAULT ::Parent:Height
   ASSIGN ::cProgId VALUE cProgId   TYPE "CM"

   nStyle := ::InitStyle( ,,, NoTabStop, lDisabled )

   nControlHandle := InitActiveX( ::ContainerhWnd, ::cProgId, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )
   ::hAtl := AtlAxGetDisp( nControlHandle )

   ::Register( nControlHandle, ControlName )

   bErrorBlock := ErrorBlock( { |x| break( x ) } )
   #ifdef __XHARBOUR__
      TRY
         ::oOle := ToleAuto():New( ::hAtl )
      CATCH oError
         MsgInfo( oError:Description )
      END
   #else
      BEGIN SEQUENCE
         ::oOle := ToleAuto():New( ::hAtl )
      RECOVER USING oError
         MsgInfo( oError:Description )
      END
   #endif
   ErrorBlock( bErrorBlock )

   SetupConnectionPoint( ::hAtl, @hSink, ::aAxEv, ::aAxExec )
   ::hSink := hSink

Return Self
*   ::CreateControl()         nControlHandle := InitActiveX( ::ContainerhWnd, ::cProgId, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TActiveX
*-----------------------------------------------------------------------------*
   SHUTDOWNCONNECTIONPOINT( ::hSink )
   ReleaseDispatch( ::hAtl )
Return ::Super:Release()

//-----------------------------------------------------------------------------------------------//
/*
 * oSkAr 20070829
 * Soporte de eventos para los controles ActiveX
 *
 * PARAMETROS
 * nMsg  == Numero de eventos
 * xExec == Puede ser un bloque de codigo, el nombre de una funcion o metodo, o un puntero a una funcion
 * oSelf == En caso de ser el nombre de un metodo se debe de pasar el objeto con el cual se va a ejecutar
 *
 * Ejemplos

   // Codeblock
   oActiveX:EventMap( 103, { |cTitle| oWnd:Title := cTitle } )

   // Nombre de funcion
   oActiveX:EventMap( 103, "ONCHANGETITLE" )

   // Metodo
   oActiveX:EventMap( 103, "ONCHANGETITLE", oMiObjeto )

   // Puntero a Funcion
   oActiveX:EventMap( 103, @OnChangeTitle )

   Function OnChangeTitle( cTitle )
      oWnd:Title := cTitle
      Return NIL

   Method OnChangeTitle( cTitle ) From MiClase
      ::oWnd:Title := cTitle
      Return NIL

 */
//-----------------------------------------------------------------------------------------------//
METHOD EventMap( nMsg, xExec, oSelf )
   LOCAL nAt
   nAt := AScan( ::aAxEv, nMsg )
   IF nAt == 0
      AAdd( ::aAxEv, nMsg )
      AAdd( ::aAxExec, { NIL, NIL } )
      nAt := Len( ::aAxEv )
   ENDIF
   ::aAxExec[ nAt ] := { xExec, oSelf }
RETURN NIL

#ifndef __XHARBOUR__       //// si es harbour 
#ifndef __BORLANDC__       //// y no es borlandc
*-----------------------------------------------------------------------------*
METHOD __Error( ... )
*-----------------------------------------------------------------------------*
Local cMessage
cMessage := __GetMessage()

//   IF SubStr( cMessage, 1, 1 ) == "_"
//      cMessage := SubStr( cMessage, 2 )
//   ENDIF

   RETURN HB_ExecFromArray( ::oOle, cMessage, HB_aParams() )

#endif
#endif
