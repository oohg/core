/*
 * $Id: h_splitbox.prg $
 */
/*
 * ooHG source code:
 * SplitBox control
 *
 * Copyright 2006-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
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
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TSplitBox FROM TControl

   DATA cGripperText              INIT ""
   DATA lForceBreak               INIT .T.
   DATA lInverted                 INIT .F.
   DATA nIdealSize                INIT NIL
   DATA nMinHeight                INIT NIL
   DATA nMinWidth                 INIT NIL
   DATA Type                      INIT "SPLITBOX" READONLY

   METHOD AddControl
   METHOD BandGripperOFF
   METHOD BandGripperON
   METHOD BandHasGripper
   METHOD ClientHeightUsed        BLOCK { |Self| GetWindowHeight( ::hWnd )  }
   METHOD Define
   METHOD Events_Size             BLOCK { |Self| SizeRebar( ::hWnd ), RedrawWindow( ::hWnd ) }
   METHOD HideBand
   METHOD IsBandVisible
   METHOD Refresh                 BLOCK { |Self| SizeRebar( ::hWnd ), RedrawWindow( ::hWnd ) }
   METHOD RefreshData             BLOCK { |Self| SizeRebar( ::hWnd ), RedrawWindow( ::hWnd ), ::Super:RefreshData() }
   METHOD SetSplitBox
   METHOD ShowBand
   METHOD SizePos                 BLOCK { |Self| SizeRebar( ::hWnd ), RedrawWindow( ::hWnd ) }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( uParentForm, lBottom, lInverted, lRtl, lNoAttached ) CLASS TSplitBox

   LOCAL nControlHandle, nStyle

   ::SetForm( NIL, uParentForm, NIL, NIL, NIL, NIL, NIL, lRtl )

   IF ::Container != NIL .AND. ! ValidHandler( ::ContainerhWndValue )
      MsgOOHGError( "SPLITBOX can't be defined inside TAB control. Program terminated." )
   ENDIF

   ASSIGN ::lInverted VALUE lInverted TYPE "L"
   ASSIGN lBottom     VALUE lBottom   TYPE "L"

   nStyle := ::InitStyle( NIL, NIL, NIL, .T. )
   IF ::lInverted
      IF lBottom
         nStyle += CCS_RIGHT
      ELSE
         nStyle += CCS_LEFT
      ENDIF
   ELSE
      IF lBottom
         nStyle += CCS_BOTTOM
      ELSE
         nStyle += CCS_TOP
      ENDIF
   ENDIF

   nControlHandle := InitSplitBox( ::ContainerhWnd, nStyle, ::lRtl )

   IF ValType( lNoAttached ) == "L" .AND. lNoAttached
      ::Style := ::Style + CCS_NOPARENTALIGN
   ENDIF

   ::Register( nControlHandle )
   ::SizePos()

   ::ContainerhWndValue := ::hWnd

   _OOHG_AddFrame( Self )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddControl( oControl ) CLASS TSplitBox

   AddSplitBoxItem( oControl:hWnd, ::hWnd, GetWindowWidth( oControl:hWnd ), ::lForceBreak, ::cGripperText, ::nMinWidth, ::nMinHeight, ::lInverted, ::nIdealSize )
   ::lForceBreak  := .F.
   ::cGripperText := NIL
   ::nMinWidth    := NIL
   ::nMinHeight   := NIL
   ::nIdealSize   := NIL

   RETURN ::Super:AddControl( oControl )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetSplitBox( Break, GripperText, nMinWidth, nMinHeight, nIdealSize ) CLASS TSplitBox

   ::lForceBreak := ::lForceBreak .OR. ( ValType( Break ) == "L" .AND. Break )
   ASSIGN ::cGripperText VALUE GripperText TYPE "CM"
   ASSIGN ::nMinWidth    VALUE nMinWidth   TYPE "N"
   ASSIGN ::nMinHeight   VALUE nMinHeight  TYPE "N"
   ASSIGN ::nIdealSize   VALUE nIdealSize  TYPE "N"

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BandGripperOFF( nBandId ) CLASS TSplitBox

   SetBandStyle( ::hWnd, nBandId, RBBS_GRIPPERALWAYS, .F. )
   SetBandStyle( ::hWnd, nBandId, RBBS_NOGRIPPER, .T. )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BandGripperON( nBandId ) CLASS TSplitBox

   SetBandStyle( ::hWnd, nBandId, RBBS_NOGRIPPER, .F. )
   SetBandStyle( ::hWnd, nBandId, RBBS_GRIPPERALWAYS, .T. )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BandHasGripper( nBandId ) CLASS TSplitBox

   RETURN ! BandHasStyleSet( ::hWnd, nBandId, RBBS_NOGRIPPER )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HideBand( nBandId ) CLASS TSplitBox

   SetBandStyle( ::hWnd, nBandId, RBBS_HIDDEN, .T. )

   RETURN ( BandHasStyleSet( ::hWnd, nBandId, RBBS_HIDDEN ) == .T. )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ShowBand( nBandId ) CLASS TSplitBox

   SetBandStyle( ::hWnd, nBandId, RBBS_HIDDEN, .F. )

   RETURN ( BandHasStyleSet( ::hWnd, nBandId, RBBS_HIDDEN ) == .F. )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsBandVisible( nBandId ) CLASS TSplitBox

   RETURN ! BandHasStyleSet( ::hWnd, nBandId, RBBS_HIDDEN )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndSplitBox()

   RETURN _OOHG_DeleteFrame( "SPLITBOX" )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _ForceBreak( ParentForm )

   LOCAL oControl

   oControl := TControl()
   oControl:SetForm( NIL, ParentForm )
   oControl:SetSplitBoxInfo( .T. )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TSplitBox_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TSplitBox_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITSPLITBOX )          /* FUNCTION IniTSplitBox( hWnd, nStyle, lRtl ) -> hWnd */
{
   HWND hCtrl;
   int Style, StyleEx;
   INITCOMMONCONTROLSEX i;
   OSVERSIONINFO osvi;
   REBARINFO rbi;

   Style = hb_parni( 2 ) | WS_CHILD | WS_CLIPSIBLINGS | RBS_BANDBORDERS | RBS_VARHEIGHT | RBS_FIXEDORDER;
   osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
   GetVersionEx( &osvi );
   if( osvi.dwMajorVersion >= 6 )
   {
      Style = Style | WS_CLIPCHILDREN;
   }
   StyleEx = _OOHG_RTL_Status( hb_parl( 3 ) ) | WS_EX_CONTROLPARENT | WS_EX_TOOLWINDOW | WS_EX_DLGMODALFRAME;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC  = ICC_COOL_CLASSES | ICC_BAR_CLASSES;
   InitCommonControlsEx( &i );

   hCtrl = CreateWindowEx( StyleEx, REBARCLASSNAME, NULL, Style,
                           0, 0, 0, 0,
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   // Initialize and send the REBARINFO structure.
   rbi.cbSize = sizeof( REBARINFO );  // Required when using this struct.
   rbi.fMask  = 0;
   rbi.himl   = ( HIMAGELIST ) NULL;
   SendMessage( hCtrl, RB_SETBARINFO, 0, ( LPARAM ) &rbi );

   _OOHG_TSplitBox_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hCtrl, GWLP_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ADDSPLITBOXITEM )          /* FUNCTION AddSplitBoxItem( CtrlhWnd, ReBarhWnd, CtrlWidth, lForceBreak, cGripperText, nMinWidth, nMinHeight, lInverted, nIdealSize ) -> NIL */
{
   REBARBANDINFO rbBand;
   RECT rc;
   int Style = RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS ;
   int iID = SendMessage( HWNDparam( 2 ), RB_GETBANDCOUNT, 0, 0 ) + 1;

   if( hb_parl( 4 ) )   // lForceBreak
   {
      Style = Style | RBBS_BREAK ;
   }

   /* NOTE: (Taken from note by "phvu" in MSDN)
      rbBand.cbSize / sizeof(REBARBANDINFO) must be 80 for WinXP ( _WIN32_WINNT == 0x0501 ) .
      Pelles C 6.00 assumes _WIN32_WINNT to 0x0600 . Then, WinXP
      refuses to work ( sizeof(REBARBANDINFO) becomes 100 ).
   */

   GetWindowRect( HWNDparam( 1 ), &rc );

   memset( &rbBand, 0, sizeof( REBARBANDINFO ) );

   rbBand.cbSize     = sizeof( REBARBANDINFO );
   rbBand.fMask      = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE | RBBIM_ID;
   if( hb_parni( 9 ) )   // nIdealSize
   {
      rbBand.fMask = rbBand.fMask | RBBIM_IDEALSIZE;
   }
   rbBand.fStyle     = Style ;
   rbBand.hbmBack    = 0;
   rbBand.wID        = iID;
   rbBand.lpText     = ( LPTSTR ) HB_UNCONST( hb_parc( 5 ) );
   rbBand.hwndChild  = HWNDparam( 1 );

   if ( ! hb_parl( 8 ) )   // ! lInverted
   {
      rbBand.cxMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
      rbBand.cyMinChild = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top ;
      rbBand.cx         = hb_parni( 3 ) ;
      if( hb_parni( 9 ) )   // nIdealSize
      {
         rbBand.cxIdeal    = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
         rbBand.cxMinChild = hb_parni( 9 );
      }
      else
      {
         rbBand.cxMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
      }
   }
   else
   {
      // Horizontal or Vertical
      if( hb_parni( 6 ) == 0 && hb_parni( 7 ) == 0 )   // nMinWidth == 0 .AND. nMinHeight == 0
      {
         // Not ToolBar
         rbBand.cxMinChild = 0 ;
         rbBand.cyMinChild = rc.right - rc.left ;
         rbBand.cx         = rc.bottom - rc.top ;
      }
      else
      {
         // ToolBar
         rbBand.cyMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0 ;
         rbBand.cx         = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top ;
         if( hb_parni( 9 ) )   // nIdealSize
         {
            rbBand.cxIdeal    = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top;
            rbBand.cxMinChild = hb_parni( 9 );
         }
         else
         {
            rbBand.cxMinChild = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top;
         }
      }
   }

   SendMessage( HWNDparam( 2 ), RB_INSERTBAND, ( WPARAM ) -1, ( LPARAM ) &rbBand );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETSPLITBOXITEM )          /* FUNCTION SetSplitBoxItem( CtrlhWnd, ReBarhWnd, CtrlWidth, lForceBreak, cGripperText, nMinWidth, nMinHeight, lInverted, nIdealSize ) -> NIL */
{
   REBARBANDINFO rbBand;
   RECT rc;
   int iCount;

   memset( &rbBand, 0, sizeof( REBARBANDINFO ) );
   rbBand.cbSize = sizeof(REBARBANDINFO);
   iCount = SendMessage( HWNDparam( 2 ), RB_GETBANDCOUNT, 0, 0 ) - 1;
   SendMessage( HWNDparam( 2 ), RB_GETBANDINFO, iCount, (LPARAM) &rbBand );

   if( HB_ISLOG( 4 ) )
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

   if( HB_ISCHAR( 5 ) )
   {
      rbBand.fMask |= RBBIM_TEXT;
      rbBand.lpText = ( LPTSTR ) HB_UNCONST( hb_parc( 5 ) );
   }

   if( HB_ISNUM( 9 ) && ( hb_parni( 9 ) > 0 ) )   // nIdealSize
   {
      rbBand.fMask = rbBand.fMask | RBBIM_IDEALSIZE;
   }

   rbBand.fMask |= RBBIM_CHILDSIZE | RBBIM_SIZE ;

   GetWindowRect( HWNDparam( 1 ), &rc );

   if ( ! hb_parl( 8 ) )   // ! lInverted
   {
      rbBand.cxMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
      rbBand.cyMinChild = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top ;
      rbBand.cx         = hb_parni( 3 ) ;

      if( hb_parni( 9 ) )   // nIdealSize
      {
         rbBand.cxIdeal    = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
         rbBand.cxMinChild = hb_parni( 9 );
      }
      else
      {
         rbBand.cxMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0;
      }
   }
   else
   {
      // Horizontal or Vertical
      if( hb_parni( 6 ) == 0 && hb_parni( 7 ) == 0 )   // nMinWidth == 0 .AND. nMinHeight == 0
      {
         // Not ToolBar
         rbBand.cxMinChild = 0 ;
         rbBand.cyMinChild = rc.right - rc.left ;
         rbBand.cx         = rc.bottom - rc.top ;
      }
      else
      {
         // ToolBar
         rbBand.cyMinChild = hb_parni( 6 ) ? hb_parni( 6 ) : 0 ;
         rbBand.cx         = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top ;
         if( hb_parni( 9 ) )   // nIdealSize
         {
            rbBand.cxIdeal    = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top;
            rbBand.cxMinChild = hb_parni( 9 );
         }
         else
         {
            rbBand.cxMinChild = hb_parni( 7 ) ? hb_parni( 7 ) : rc.bottom - rc.top;
         }
      }
   }

   SendMessage( HWNDparam( 2 ), RB_SETBANDINFO, iCount, (LPARAM) &rbBand );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL GetBandStyle( HWND hWnd, int nBandIndex, int nStyle )
{
   REBARBANDINFO rbBand;

   memset( &rbBand, 0, sizeof( REBARBANDINFO ) );
   rbBand.cbSize = sizeof(REBARBANDINFO);
   rbBand.fMask = RBBIM_STYLE;

   SendMessage( hWnd, RB_GETBANDINFO, nBandIndex, (LPARAM) &rbBand );

   return( rbBand.fStyle & nStyle );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void SetBandStyle( HWND hWnd, int nBandId, int nStyle, BOOL nSet )
{
   REBARBANDINFO rbBand;
   int nBandIndex = SendMessage( hWnd, RB_IDTOINDEX, nBandId, 0 );

   if( nBandIndex == -1 )
   {
      return;
   }

   memset( &rbBand, 0, sizeof( REBARBANDINFO ) );
   rbBand.cbSize = sizeof(REBARBANDINFO);
   rbBand.fMask = RBBIM_STYLE;

   SendMessage( hWnd, RB_GETBANDINFO, nBandIndex, (LPARAM) &rbBand );

   if( nSet )
   {
      rbBand.fStyle |= nStyle;
   }
   else
   {
      rbBand.fStyle &= ~nStyle;
   }

   SendMessage( hWnd, RB_SETBANDINFO, nBandIndex, (LPARAM) &rbBand );

   if( GetBandStyle( hWnd, nBandIndex, RBBS_HIDDEN ) == FALSE )
   {
      SendMessage( hWnd, RB_SHOWBAND, ( WPARAM ) nBandIndex, ( LPARAM )( BOOL ) 0 );
      SendMessage( hWnd, RB_SHOWBAND, ( WPARAM ) nBandIndex, ( LPARAM )( BOOL ) 1 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETBANDSTYLE )
{
   /*
    * Second received parameter is the position of the
    * band at splibox's creation time.
    *
    */
   SetBandStyle( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parl( 4 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( BANDHASSTYLESET )
{
   /*
    * Second received parameter is the position of the
    * band at splibox's creation time.
    *
    */
   int nBandIndex = SendMessage( HWNDparam( 1 ), RB_IDTOINDEX, hb_parni( 2 ), 0 );

   if( nBandIndex == -1 )
   {
      hb_retl( FALSE );
   }

   hb_retl( GetBandStyle( HWNDparam( 1 ), nBandIndex, hb_parni( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SIZEREBAR )
{
   int nCount = SendMessage( HWNDparam( 1 ), RB_GETBANDCOUNT, 0, 0 );
   int i;

   for( i = 0; i < nCount; i++ )
   {
      if( GetBandStyle( HWNDparam( 1 ), i, RBBS_HIDDEN ) == FALSE )
      {
         SendMessage( HWNDparam( 1 ), RB_SHOWBAND, ( WPARAM ) i, ( LPARAM )( BOOL ) 0 );
         SendMessage( HWNDparam( 1 ), RB_SHOWBAND, ( WPARAM ) i, ( LPARAM )( BOOL ) 1 );
      }
   }
}

#pragma ENDDUMP
