/*
 * $Id: h_media.prg $
 */
/*
 * ooHG source code:
 * Multimedia Player and AnimateBox controls
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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

CLASS TPlayer FROM TControl

   DATA Type      INIT "PLAYER" READONLY

   METHOD Define
   METHOD Release

   METHOD Play()             BLOCK { |Self| mcifunc( ::hWnd,  1 ) }
   METHOD Stop()             BLOCK { |Self| mcifunc( ::hWnd,  2 ) }
   METHOD Pause()            BLOCK { |Self| mcifunc( ::hWnd,  3 ) }
   METHOD Close()            BLOCK { |Self| mcifunc( ::hWnd,  4 ) }
   METHOD Eject()            BLOCK { |Self| mcifunc( ::hWnd,  6 ) }
   METHOD PositionEnd()      BLOCK { |Self| mcifunc( ::hWnd,  7 ) }
   METHOD PositionHome()     BLOCK { |Self| mcifunc( ::hWnd,  8 ) }
   METHOD Open(File)         BLOCK { |Self,File| mcifunc( ::hWnd,  9, File ) }
   METHOD OpenDialog()       BLOCK { |Self| mcifunc( ::hWnd, 10 ) }
   METHOD PlayReverse()      BLOCK { |Self| mcifunc( ::hWnd, 11 ) }
   METHOD Resume()           BLOCK { |Self| mcifunc( ::hWnd, 12 ) }
   METHOD Repeat(Status)     BLOCK { |Self,Status| mcifunc( ::hWnd, 13, Status ) }
   METHOD RepeatOn()         BLOCK { |Self| mcifunc( ::hWnd, 13, .t. ) }
   METHOD RepeatOff()        BLOCK { |Self| mcifunc( ::hWnd, 13, .f. ) }
   METHOD Speed(Speed)       BLOCK { |Self,Speed| mcifunc( ::hWnd, 14, Speed ) }
   METHOD Zoom(Zoom)         BLOCK { |Self,Zoom| mcifunc( ::hWnd, 16, Zoom ) }
   METHOD Length()           BLOCK { |Self| mcifunc( ::hWnd, 17 ) }
   METHOD Volume             SETGET
   METHOD Position           SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, file, col, row, w, h, noasw, noasm, ;
               noed, nom, noo, nop, sha, shm, shn, shp, HelpId, Invisible, ;
               NoTabStop, lDisabled, lRtl ) CLASS TPlayer

   Local hh, nStyle

   ASSIGN ::nCol    VALUE col TYPE "N"
   ASSIGN ::nRow    VALUE row TYPE "N"
   ASSIGN ::nWidth  VALUE w   TYPE "N"
   ASSIGN ::nHeight VALUE h   TYPE "N"

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )

   IF HB_IsLogical( sha ) .AND. sha
      shm := shn := shp := .T.
   ENDIF

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             WS_CHILD + WS_BORDER + ;
             IF( HB_IsLogical( noasw ) .AND. noasw, MCIWNDF_NOAUTOSIZEWINDOW,  0 ) + ;
             IF( HB_IsLogical( noasm ) .AND. noasm, MCIWNDF_NOAUTOSIZEMOVIE,  0 ) + ;
             IF( HB_IsLogical( noed )  .AND. noed, MCIWNDF_NOERRORDLG,  0 ) + ;
             IF( HB_IsLogical( nom ) .AND. nom, MCIWNDF_NOMENU,  0 ) + ;
             IF( HB_IsLogical( noo ) .AND. noo, MCIWNDF_NOOPEN,  0 ) + ;
             IF( HB_IsLogical( nop ) .AND. nop, MCIWNDF_NOPLAYBAR,  0 ) + ;
             IF( HB_IsLogical( shm ) .AND. shm, MCIWNDF_SHOWMODE,  0 ) + ;
             IF( HB_IsLogical( shn ) .AND. shn, MCIWNDF_SHOWNAME,  0 ) + ;
             IF( HB_IsLogical( shp ) .AND. shp, MCIWNDF_SHOWPOS,  0 )

   hh := InitPlayer ( ::ContainerhWnd, file, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )

   ::Register( hh, ControlName, HelpId )

   Return Self

METHOD Release() CLASS TPlayer

   mcifunc( ::hWnd, 5 )

   RETURN ::Super:Release()

METHOD Volume( nVolume ) CLASS TPlayer

   IF HB_IsNumeric( nVolume )
      mcifunc( ::hWnd, 15, nVolume )
   ENDIF

   Return mcifunc( ::hWnd, 19 )

METHOD Position( nPosition ) CLASS TPlayer

   IF HB_IsNumeric( nPosition )
      mcifunc( ::hWnd, 20, nPosition )
   ENDIF

   Return mcifunc( ::hWnd, 18 )

Function PlayWave(wave,r,s,ns,l,nd)

   if PCount() == 1
      r := .F.
      s := .F.
      ns := .F.
      l := .F.
      nd := .F.
   endif

   c_PlayWave(wave,r,s,ns,l,nd)

   Return Nil

Function PlayWaveFromResource(wave)

   c_PlayWave(wave,.t.,.f.,.f.,.f.,.f.)

   Return Nil


CLASS TAnimateBox FROM TControl

   DATA Type      INIT "ANIMATEBOX" READONLY

   METHOD Define

   METHOD Release            BLOCK { |Self| destroyanimate( ::hWnd ) , ::Super:Release() }
   METHOD Open(File)         BLOCK { |Self,File| openanimate( ::hWnd, File ) }
   METHOD Play               BLOCK { |Self| playanimate( ::hWnd ) }
   METHOD Stop               BLOCK { |Self| stopanimate( ::hWnd ) }
   METHOD Close              BLOCK { |Self| closeanimate( ::hWnd ) }
   METHOD Seek(Frame)        BLOCK { |Self,Frame| seekanimate( ::hWnd, Frame ) }

   ENDCLASS

METHOD Define( ControlName, ParentForm, nCol, nRow, nWidth, nHeight, lAutoplay, ;
               lCenter, lTransparent, cFile, nHelpId, lInvisible, lNoTabStop, ;
               lDisabled, lRtl, cToolTip ) CLASS TAnimateBox

   Local hh, nStyle

   ASSIGN ::nCol    VALUE nCol    TYPE "N"
   ASSIGN ::nRow    VALUE nRow    TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   ::SetForm( ControlName, ParentForm, , , , , , lRtl )

   nStyle := ::InitStyle( , , lInvisible, lNoTabStop, lDisabled ) + ;
             WS_CHILD + WS_BORDER + ;
             If( HB_IsLogical( lAutoplay ) .AND. lAutoplay, ACS_AUTOPLAY, 0 ) + ;
             If( HB_IsLogical( lCenter ) .AND. lCenter, ACS_CENTER, 0 ) + ;
             If( HB_IsLogical( lTransparent ) .AND. lTransparent, ACS_TRANSPARENT, 0 )

   hh := InitAnimate( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )

   ::Register( hh, ControlName, nHelpId, , cToolTip )

   If ValType( cFile ) <> 'U'
      ::Open( cFile )
   EndIf

   Return Self


EXTERN MCIFUNC

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>
#include <vfw.h>
#include <commctrl.h>
#include "oohg.h"

// This fixes a warning over dwICValue
HB_FUNC( ICGETDEFAULTQUALITY )
{
   hb_retnl( ( LONG ) ICGetDefaultQuality( (HIC) hb_parnl( 1 ) ) );
}

HB_FUNC( ICGETDEFAULTKEYFRAMERATE )
{
   hb_retnl( ( LONG ) ICGetDefaultKeyFrameRate( (HIC) hb_parnl( 1 ) ) );
}

/*
static WNDPROC lpfnOldWndProcA = 0;
static WNDPROC lpfnOldWndProcB = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcB );
}
*/

HB_FUNC( INITANIMATE )
{
   HWND hwnd;

   hwnd = Animate_Create( HWNDparam( 1 ), NULL, hb_parni( 6 ), GetModuleHandle( NULL ) );

   if( ! hwnd )
   {
      MessageBox(0, "AnimateBox Creation Failed!", "Error!",
      MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
      return;
   }

//   lpfnOldWndProcA = (WNDPROC) SetWindowLongPtr( hwnd, GWL_WNDPROC, (LONG_PTR) SubClassFuncA );

   MoveWindow( hwnd, hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), TRUE );
   HWNDret( hwnd );
}

HB_FUNC( OPENANIMATE )
{
   Animate_Open( HWNDparam( 1 ), hb_parc(2));
}

HB_FUNC( PLAYANIMATE )
{
   Animate_Play( HWNDparam( 1 ), 0, -1, 1 );
}

HB_FUNC( SEEKANIMATE )
{
   Animate_Seek( HWNDparam( 1 ), hb_parni(2));
}

HB_FUNC( STOPANIMATE )
{
   Animate_Stop( HWNDparam( 1 ) );
}

HB_FUNC( CLOSEANIMATE )
{
   Animate_Close( HWNDparam( 1 ) );
}

HB_FUNC( DESTROYANIMATE )
{
   DestroyWindow( HWNDparam( 1 ) );
}

HB_FUNC( INITPLAYER )
{
   HWND hwnd;

   hwnd = MCIWndCreate( HWNDparam( 1 ), NULL, hb_parni( 7 ), hb_parc( 2 ) );

   if( ! hwnd )
   {
      MessageBox(0, "Player Creation Failed!", "Error!",
      MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
      return;
   }

//   lpfnOldWndProcB = (WNDPROC) SetWindowLongPtr( hwnd, GWL_WNDPROC, (LONG_PTR) SubClassFuncB );

   MoveWindow( hwnd, hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), hb_parnl( 6 ), TRUE );
   HWNDret( hwnd );
}

HB_FUNC( MCIFUNC )
{
   HWND mcihand = HWNDparam( 1 );
   int  func = hb_parni( 2 );

   switch( func )
   {
      case  1:  hb_retnl( MCIWndPlay(mcihand)) ; break;
      case  2:  hb_retnl( MCIWndStop(mcihand)) ; break;
      case  3:  hb_retnl( MCIWndPause(mcihand)) ; break;
      case  4:  hb_retnl( MCIWndClose(mcihand)) ; break;
      case  5:            MCIWndDestroy(mcihand) ; hb_retnl(0);break;
      case  6:  hb_retnl( MCIWndEject(mcihand)) ; break;
      case  7:  hb_retnl( MCIWndEnd(mcihand)) ; break;
      case  8:  hb_retnl( MCIWndHome(mcihand)) ; break;
      case  9:  hb_retnl( MCIWndOpen(mcihand,hb_parc(3),NULL)) ; break;
      case 10:  hb_retnl( MCIWndOpenDialog(mcihand)) ; break;
      case 11:  hb_retnl( MCIWndPlayReverse(mcihand)) ; break;
      case 12:  hb_retnl( MCIWndResume(mcihand)) ; break;
      case 13:            MCIWndSetRepeat(mcihand,hb_parl(3)) ;hb_retnl(0); break;
      case 14:  hb_retnl( MCIWndSetSpeed(mcihand,hb_parni(3))) ; break;
      case 15:  hb_retnl( MCIWndSetVolume(mcihand,hb_parni(3))) ; break;
      case 16:            MCIWndSetZoom(mcihand,hb_parni(3)) ; hb_retnl(0); break;
      case 17:  hb_retnl( MCIWndGetLength(mcihand)) ; break;
      case 18:  hb_retnl( MCIWndGetPosition(mcihand)) ; break;
      case 19:  hb_retnl( MCIWndGetVolume(mcihand) ) ; break;
      case 20:  hb_retnl( MCIWndSeek(mcihand,hb_parni(3)) ) ; hb_retnl(0); break;
      default: hb_retnl( 0 ) ;
   }
}

#pragma ENDDUMP
