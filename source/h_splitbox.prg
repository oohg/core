/*
 * $Id: h_splitbox.prg,v 1.10 2009-03-22 22:39:59 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Splitbox control
 *
 * Copyright 2006-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TSplitBox FROM TControl
   DATA Type           INIT "SPLITBOX" READONLY
   DATA lForceBreak    INIT .T.
   DATA cGripperText   INIT ""
   DATA lInverted      INIT .F.
   DATA nMinWidth      INIT nil
   DATA nMinHeight     INIT nil

   METHOD Define
   METHOD SizePos        BLOCK { |Self| SizeRebar( ::hWnd ) , RedrawWindow( ::hWnd ) }
   METHOD Refresh        BLOCK { |Self| SizeRebar( ::hWnd ) , RedrawWindow( ::hWnd ) }
   METHOD Events_Size    BLOCK { |Self| SizeRebar( ::hWnd ) , RedrawWindow( ::hWnd ) }
   METHOD RefreshData    BLOCK { |Self| SizeRebar( ::hWnd ) , RedrawWindow( ::hWnd ) , ::Super:RefreshData() }
   METHOD AddControl
   METHOD SetSplitBox
   METHOD ClientHeightUsed     BLOCK { |Self| GetWindowHeight( ::hWnd ) * IF( ::lTop, 1, -1 ) }

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ParentForm, bottom, inverted, lRtl, noattached ) CLASS TSplitBox
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ::SetForm( , ParentForm,,,,,, lRtl )

   If ::Container != nil .AND. ! ValidHandler( ::ContainerhWndValue )
      MsgOOHGError( "SPLITBOX can't be defined inside Tab control. Program terminated." )
	EndIf

   ASSIGN ::lInverted VALUE inverted   TYPE "L"
   ASSIGN bottom      VALUE bottom     TYPE "L"

   nStyle := ::InitStyle( ,,, .T. )
   If ::lInverted
      If bottom
         nStyle += CCS_RIGHT
      Else
         nStyle += CCS_LEFT
      EndIf
   Else
      If bottom
         nStyle += CCS_BOTTOM
      Else
         nStyle += CCS_TOP
      EndIf
   EndIf

   ControlHandle := InitSplitBox( ::ContainerhWnd, nStyle, ::lRtl )

   If VALTYPE( noattached ) == "L" .AND. noattached
      ::Style := ::Style + CCS_NOPARENTALIGN
   EndIf

   ::Register( ControlHandle )
   ::SizePos()

   ::ContainerhWndValue := ::hWnd

   _OOHG_AddFrame( Self )

Return Self

*-----------------------------------------------------------------------------*
METHOD AddControl( oControl ) CLASS TSplitBox
*-----------------------------------------------------------------------------*
   AddSplitBoxItem( oControl:hWnd, ::hWnd, GetWindowWidth( oControl:hWnd ), ::lForceBreak, ::cGripperText, ::nMinWidth, ::nMinHeight, ::lInverted )
   ::lForceBreak  := .F.
   ::cGripperText := nil
   ::nMinWidth    := nil
Return ::Super:AddControl( oControl )

*-----------------------------------------------------------------------------*
METHOD SetSplitBox( Break, GripperText, nMinWidth, nMinHeight ) CLASS TSplitBox
*-----------------------------------------------------------------------------*
   ::lForceBreak := ::lForceBreak .OR. ( ValType( Break ) == "L" .AND. Break )
   If ValType( GripperText ) $ "CM"
      ::cGripperText := GripperText
   EndIf
   If ValType( nMinWidth ) == "N"
      ::nMinWidth := nMinWidth
   EndIf
   If ValType( nMinHeight ) == "N"
      ::nMinHeight := nMinHeight
   EndIf
Return .T.

*-----------------------------------------------------------------------------*
Function _EndSplitBox()
*-----------------------------------------------------------------------------*
Return _OOHG_DeleteFrame( "SPLITBOX" )

*-----------------------------------------------------------------------------*
Function _ForceBreak( ParentForm )
*-----------------------------------------------------------------------------*
Local oControl
   oControl := TControl()
   oControl:SetForm( , ParentForm )
   oControl:SetSplitBoxInfo( .T. )
Return nil

EXTERN SetSplitBoxItem

#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITSPLITBOX )
{
   HWND hwndOwner = HWNDparam( 1 );
   REBARINFO     rbi;
   HWND   hwndRB;
   INITCOMMONCONTROLSEX icex;
   int ExStyle;
   int Style;

   ExStyle = _OOHG_RTL_Status( hb_parl( 3 ) );

   Style = hb_parni( 2 ) |
           WS_CHILD |
           WS_CLIPSIBLINGS |
           WS_CLIPCHILDREN |
           RBS_BANDBORDERS |
           RBS_VARHEIGHT |
           RBS_FIXEDORDER;

   icex.dwSize = sizeof( INITCOMMONCONTROLSEX );
   icex.dwICC  = ICC_COOL_CLASSES | ICC_BAR_CLASSES;
   InitCommonControlsEx( &icex );

   hwndRB = CreateWindowEx( ExStyle | WS_EX_TOOLWINDOW | WS_EX_DLGMODALFRAME,
                            REBARCLASSNAME,
                            NULL,
                            Style,
                            0,0,0,0,
                            hwndOwner,
                            NULL,
                            GetModuleHandle( NULL ),
                            NULL );

   // Initialize and send the REBARINFO structure.
   rbi.cbSize = sizeof( REBARINFO );  // Required when using this struct.
   rbi.fMask  = 0;
   rbi.himl   = ( HIMAGELIST ) NULL;
   SendMessage( hwndRB, RB_SETBARINFO, 0, ( LPARAM ) &rbi );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hwndRB, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hwndRB );
}

HB_FUNC( SIZEREBAR )
{
   SendMessage( HWNDparam( 1 ), RB_SHOWBAND, ( WPARAM )( INT ) 0, ( LPARAM )( BOOL ) 0 );
   SendMessage( HWNDparam( 1 ), RB_SHOWBAND, ( WPARAM )( INT ) 0, ( LPARAM )( BOOL ) 1 );
}

HB_FUNC ( ADDSPLITBOXITEM )
{

  REBARBANDINFO rbBand;
  RECT          rc;
  int Style = RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS ;

  if ( hb_parl (4) )
  {
     Style = Style | RBBS_BREAK ;
  }

  GetWindowRect( HWNDparam( 1 ) , &rc );

  rbBand.cbSize = sizeof(REBARBANDINFO);
  rbBand.fMask  = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE ;
  rbBand.fStyle = Style ;
  rbBand.hbmBack= 0;

  rbBand.lpText     = hb_parc(5);
  rbBand.hwndChild  = HWNDparam( 1 );


  if ( !hb_parl (8) )
  {
     // Not Horizontal
     rbBand.cxMinChild = hb_parni(6) ? hb_parni(6) : 0 ;       //0 ; JP 61
     rbBand.cyMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
     rbBand.cx         = hb_parni(3) ;
  }
  else
  {
     // Horizontal
     if ( hb_parni(6) == 0 && hb_parni(7) == 0 )
     {
        // Not ToolBar
        rbBand.cxMinChild = 0 ;
        rbBand.cyMinChild = rc.right - rc.left ;
        rbBand.cx         = rc.bottom - rc.top ;
     }
     else
     {
        // ToolBar
        rbBand.cxMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
        rbBand.cyMinChild = hb_parni(6) ? hb_parni(6) : 0 ;
        rbBand.cx         = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ;

     }
  }

  SendMessage( HWNDparam( 2 ) , RB_INSERTBAND , (WPARAM)-1 , (LPARAM) &rbBand );

}

HB_FUNC( SETSPLITBOXITEM )
{
	REBARBANDINFO rbBand;
	RECT          rc;
   int iCount;

   memset( &rbBand, 0, sizeof( REBARBANDINFO ) );
	rbBand.cbSize = sizeof(REBARBANDINFO);
   iCount = SendMessage( HWNDparam( 2 ) , RB_GETBANDCOUNT, 0 , 0 ) - 1;
   SendMessage( HWNDparam( 2 ) , RB_GETBANDINFO, iCount, (LPARAM) &rbBand );

   if( ISLOG( 4 ) )
   {
      rbBand.fMask |= RBBIM_STYLE;
      if( hb_parl( 4 ) )
      {
         rbBand.fStyle |=  RBBS_BREAK;
      }
      else
      {
         rbBand.fStyle &= ~RBBS_BREAK;
      }
   }

   if( ISCHAR( 5 ) )
   {
      rbBand.fMask |= RBBIM_TEXT;
      rbBand.lpText = hb_parc( 5 );
   }

   GetWindowRect( HWNDparam( 1 ), &rc );

   rbBand.fMask  |= RBBIM_CHILDSIZE | RBBIM_SIZE ;

   // rbBand.hwndChild  = HWNDparam( 1 );

	if ( !hb_parl (8) )
	{
		// Not Horizontal
		rbBand.cxMinChild = hb_parni(6) ? hb_parni(6) : 0 ;       //0 ; JP 61
		rbBand.cyMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
		rbBand.cx         = hb_parni(3) ;
	}
	else
	{
		// Horizontal
		if ( hb_parni(6) == 0 && hb_parni(7) == 0 )
		{
			// Not ToolBar
			rbBand.cxMinChild = 0 ;
			rbBand.cyMinChild = rc.right - rc.left ;
			rbBand.cx         = rc.bottom - rc.top ;
		}
		else
		{
			// ToolBar
			rbBand.cxMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
			rbBand.cyMinChild = hb_parni(6) ? hb_parni(6) : 0 ;
			rbBand.cx         = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ;
		}
	}

   SendMessage( HWNDparam( 2 ), RB_SETBANDINFO, iCount, (LPARAM) &rbBand );
}

#pragma ENDDUMP
