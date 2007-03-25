/*
 * $Id: h_activex.prg,v 1.1 2007-03-25 22:41:42 guerra000 Exp $
 */
/*
 * ooHG source code:
 * ActiveX control
 *
 *  Marcelo Torres, Noviembre de 2006.
 *  TActivex para [x]Harbour Minigui.
 *  Adaptacion del trabajo de:
 *  ---------------------------------------------
 *  Lira Lira Oscar Joel [oSkAr]
 *  Clase TAxtiveX_FreeWin para Fivewin
 *  Noviembre 8 del 2006
 *  email: oscarlira78@hotmail.com
 *  http://freewin.sytes.net
 *  @CopyRight 2006 Todos los Derechos Reservados
 *  ---------------------------------------------
 *  Implemented by ooHG team.
 */

#include "oohg.ch"
#include "hbclass.ch"

CLASS TActiveX FROM TControl
   DATA Type      INIT "ACTIVEX" READONLY
   DATA nWidth    INIT nil
   DATA nHeight   INIT nil
   DATA oOle      INIT nil
   DATA cProgId   INIT ""

   METHOD Define

   DELEGATE Set TO oOle
   DELEGATE Get TO oOle
   ERROR HANDLER __Error
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, cProgId, ;
               NoTabStop, lDisabled ) CLASS TActiveX
*-----------------------------------------------------------------------------*
LOCAL nStyle, oError, nControlHandle, hAtl, bErrorBlock

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
   hAtl := AtlAxGetDisp( nControlHandle )

   ::Register( nControlHandle, ControlName )

   bErrorBlock := ErrorBlock( { |x| break( x ) } )
   #ifdef __XHARBOUR__
      TRY
         ::oOle := ToleAuto():New( hAtl )
      CATCH
         MsgInfo( oError:Description )
      END
   #else
      BEGIN SEQUENCE
         ::oOle := ToleAuto():New( hAtl )
      RECOVER USING oError
         MsgInfo( oError:Description )
      END
   #endif
   ErrorBlock( bErrorBlock )

Return Self

*-----------------------------------------------------------------------------*
METHOD __Error( uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 ) CLASS TActiveX
*-----------------------------------------------------------------------------*
Local cMessage, uRet
   cMessage := __GetMessage()
   If     PCOUNT() == 0
      uRet := ::oOle:Set( cMessage )
   ElseIf PCOUNT() == 1
      uRet := ::oOle:Set( cMessage, uParam1 )
   ElseIf PCOUNT() == 2
      uRet := ::oOle:Set( cMessage, uParam1, uParam2 )
   ElseIf PCOUNT() == 3
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3 )
   ElseIf PCOUNT() == 4
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4 )
   ElseIf PCOUNT() == 5
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4, uParam5 )
   ElseIf PCOUNT() == 6
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6 )
   ElseIf PCOUNT() == 7
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7 )
   ElseIf PCOUNT() == 8
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8 )
   Else
      uRet := ::oOle:Set( cMessage, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 )
   EndIf
Return uRet

/*-----------------------------------------------------------------------------------------------*/

#pragma BEGINDUMP
#include <windows.h>
#include <commctrl.h>
#include <hbapi.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

typedef HRESULT ( WINAPI *LPAtlAxWinInit )    ( void );
typedef HRESULT ( WINAPI *LPAtlAxGetControl ) ( HWND hwnd, IUnknown** unk );

HMODULE hAtl = NULL;
LPAtlAxWinInit    AtlAxWinInit;
LPAtlAxGetControl AtlAxGetControl;

static void _Ax_Init( void )
{
   if( ! hAtl )
   {
      hAtl = LoadLibrary( "Atl.Dll" );
      AtlAxWinInit    = ( LPAtlAxWinInit )    GetProcAddress( hAtl, "AtlAxWinInit" );
      AtlAxGetControl = ( LPAtlAxGetControl ) GetProcAddress( hAtl, "AtlAxGetControl" );
      ( AtlAxWinInit )();
   }
}

HB_FUNC_STATIC( INITACTIVEX ) // hWnd, cProgId -> hActiveXWnd
{
   HWND hControl;
   int iStyle, iStyleEx;

   iStyle = WS_VISIBLE | WS_CHILD | hb_parni( 7 );
   iStyleEx = 0; // | WS_EX_CLIENTEDGE

   _Ax_Init();
   hControl = CreateWindowEx( iStyleEx, "AtlAxWin", hb_parc( 2 ), iStyle,
              hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), HWNDparam( 1 ), 0, 0, NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hControl, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hControl );
}

HB_FUNC( ATLAXGETDISP ) // hWnd -> pDisp
{
   IUnknown *pUnk;
   IDispatch *pDisp;
   _Ax_Init();
   AtlAxGetControl( HWNDparam( 1 ), &pUnk );
   pUnk->lpVtbl->QueryInterface( pUnk, &IID_IDispatch, ( void ** ) &pDisp );
   HWNDret( pDisp );
}

#pragma ENDDUMP
